`release-cmd` is a tool to help us with project management and statistics based on git `Merge pull request...`
commits, `release-cmd` functions:

1. Create [GitHub Release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)
between 2 branches, commit hashes or tags.

2. Report All Member Efforts (.md or .csv file).

3. Report Per Member Efforts.

## Install:

`npm i -g release-cmd`

and install [gh-cli](https://cli.github.com/) for dependency.

## Usage:

- Open terminal, type `release-cmd`
- Continue typing:

> `github` or `gh` to create GitHub Release

> `md` to generate Report All Member Efforts in .md format

> `mdu` to generate Report Per Member Efforts in .md format

> `csv` to generate Report All Member Efforts in .csv format

---

Thanks to the library [Vorpal](https://github.com/dthree/vorpal) for helping us with this project.
