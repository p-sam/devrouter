const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');
const nunjucks = require('nunjucks');

const SITE_ENV_PREFIX = 'SITE_';
const BASE_PATH = path.resolve(__dirname, '../');

console.log('> reading sites...');
const sites = {};
const env = dotenv.parse(fs.readFileSync(path.resolve(BASE_PATH, './.env')));

const title = env.TITLE.trim() || 'Dev Router';
const domain = process.env.DOMAIN; // reading from the real env so its value is in sync with the dns container

for(let i in env) {
    if(!env.hasOwnProperty(i)) continue;
    if(!i.startsWith(SITE_ENV_PREFIX)) continue;

    sites[i.substr(SITE_ENV_PREFIX.length)] = env[i];
}

console.log(`> found ${Object.keys(sites).length}!`);

for(let tpl of ['Caddyfile','index.html']) {
    console.log(`> rendering ${tpl}...`);
    let res = nunjucks.render(tpl+'.njk', {sites, title, domain});
    fs.writeFileSync(path.resolve(BASE_PATH, './caddy/'+tpl), res);
}
