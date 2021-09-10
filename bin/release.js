#!/usr/bin/env node
const vorpal = require('vorpal')();
const {execSync} = require('child_process');

vorpal.command('github').action(async function(args, cb) {
  // const self = this;
  const file = fpath('/release_github.sh');
  let from = cmd(`git describe --tags --abbrev=0`);
  let to = cmd(`git branch --show-current`);

  await this.prompt({
    type: 'input',
    name: 'from',
    default: from,
    message: 'from commit hash or tag or branch: ',
  }, function(result) {
    // console.log(result);
    from = result.from;
  });
  await this.prompt({
    type: 'input',
    name: 'to',
    default: to,
    message: 'to commit hash or tag or branch: ',
  }, function(result) {
    // console.log(result);
    to = result.to;
  });
  this.log(sh(file, from, to));
});

vorpal.command('md').action(async function(args, cb) {
  // const self = this;
  let on = cmd(`git branch --show-current`);
  let since = cmd(`date -v1d -v"$(date '+%m')"m '+%F'`);
  let until = cmd(`date "+%F"`);

  await this.prompt({
    type: 'input',
    name: 'on',
    default: on,
    message: 'on tag or branch: ',
  }, function(result) {
    // console.log(result);
    on = result.on;
  });
  await this.prompt({
    type: 'input',
    name: 'since',
    default: since,
    message: 'since date: ',
  }, function(result) {
    // console.log(result);
    since = result.since;
  });
  await this.prompt({
    type: 'input',
    name: 'until',
    default: until,
    message: 'until date: ',
  }, function(result) {
    // console.log(result);
    until = result.until;
  });
  const mmdFile = fpath('/report-month-md-all.sh');

  this.log(sh(mmdFile, on, since, until));
});
vorpal.command('mdu').action(async function(args, cb) {
  // const self = this;
  let on = cmd(`git branch --show-current`);
  let since = cmd(`date -v1d -v"$(date '+%m')"m '+%F'`);
  let until = cmd(`date "+%F"`);

  await this.prompt({
    type: 'input',
    name: 'on',
    default: on,
    message: 'on tag or branch: ',
  }, function(result) {
    // console.log(result);
    on = result.on;
  });
  await this.prompt({
    type: 'input',
    name: 'since',
    default: since,
    message: 'since date: ',
  }, function(result) {
    // console.log(result);
    since = result.since;
  });
  await this.prompt({
    type: 'input',
    name: 'until',
    default: until,
    message: 'until date: ',
  }, function(result) {
    // console.log(result);
    until = result.until;
  });
  const file = fpath('/report-month-md-by-user.sh');

  this.log(sh(file, on, since, until));
});

vorpal.command('csv').action(async function(args, cb) {
  // const self = this;
  let on = cmd(`git branch --show-current`);
  let since = cmd(`date -v1d -v"$(date '+%m')"m '+%F'`);
  let until = cmd(`date "+%F"`);

  await this.prompt({
    type: 'input',
    name: 'on',
    default: on,
    message: 'on tag or branch: ',
  }, function(result) {
    // console.log(result);
    on = result.on;
  });
  await this.prompt({
    type: 'input',
    name: 'since',
    default: since,
    message: 'since date: ',
  }, function(result) {
    // console.log(result);
    since = result.since;
  });
  await this.prompt({
    type: 'input',
    name: 'until',
    default: until,
    message: 'until date: ',
  }, function(result) {
    // console.log(result);
    until = result.until;
  });
  const file = fpath('/report-month-csv-all.sh');

  this.log(sh(file, on, since, until));
});

vorpal.delimiter('release $').show();

//helpers
function sh(...args) {
  return execSync(`sh ${args.join(' ')}`).toString().trim();
}

function cmd(str) {
  return execSync(str).toString().trim();
}

function fpath(name) {
  return __dirname + name;
}
