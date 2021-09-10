#!/usr/bin/env node
const vorpal = require('vorpal')();
const {execSync, exec} = require('child_process');
const file = __dirname + '/release_github.sh';

// const {Command} = require('commander');
// const program = new Command();
// program.option('-f, --from', 'from commit hash or tag or branch').
//     option('-t, --to', 'to commit hash or tag or branch');
//
// program.parse(process.argv);
//
// const options = program.opts();
// console.log(options);
//
//
let from =
    execSync(`git describe --tags --abbrev=0`).toString().trim();
let to = execSync(`git branch --show-current`).toString().trim();

vorpal.command('github').action(async function(args, cb) {
  // const self = this;
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
  this.log(runBashWithFromTo(from, to));
});

vorpal.delimiter('release $').show();

//
function runBashWithFromTo(from, to) {
  return execSync(`sh ${file} ${from} ${to}`).toString();
}
