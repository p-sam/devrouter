const fs = require('fs');
const path = require('path');
const spawn = require('cross-spawn');
const dotenv = require('dotenv');
const nunjucks = require('nunjucks');

const SITE_ENV_PREFIX = 'SITE_';
const BASE_PATH = path.resolve(__dirname, '../');

console.log('> reading sites...');
const sites = {};
const env = dotenv.parse(fs.readFileSync(path.resolve(BASE_PATH, './.env')));

const title = env.TITLE ? env.TITLE.trim() : 'Dev Router';
const domain = process.env.DOMAIN ? process.env.DOMAIN.trim() : null; // reading from the real env so its value is in sync with the dns container

for(let i in env) {
    if(!env.hasOwnProperty(i)) continue;
    if(!i.startsWith(SITE_ENV_PREFIX)) continue;

    sites[i.substr(SITE_ENV_PREFIX.length)] = env[i];
}

console.log(`> found ${Object.keys(sites).length}!`);

if(domain) {
    for(let site of Object.keys(sites)) {
        console.log(`> makecert ${site}...`);
        const res = spawn.sync(path.resolve(__dirname, './makecert.sh'), [`${site}.${domain}`], {shell: true, stdio: 'pipe'});
        if(res.stderr) {
            console.log(res.stderr.toString());
        }
        //console.log(res.stdout.toString());
        if(res.status) {
            throw new Error('makecert.sh existed with code ' + res.status);
        }
    }
}

for(let tpl of ['Caddyfile','index.html']) {
    console.log(`> rendering ${tpl}...`);
    let res = nunjucks.render(tpl+'.njk', {sites, title, domain});
    fs.writeFileSync(path.resolve(BASE_PATH, './caddy/'+tpl), res);
}
