#  toolbox 

A collection of tools and configurations for my development environment.

I use this repository to manage my development environment across different machines, operating systems, containers, and cloud workspaces. The repository is designed to be cloned and run on a Ubuntu or MacOS system (only tested on my computers, ymmv).

## Usage

Used on local machines and docker based development containers.

### Local

How I currently run the `toolbox` setup locally:

    $ git clone https://github.com/ecshreve/toolbox.git ~/.toolbox

    $ cd ~/.toolbox

    $ ./setup.sh

    $ ansible-playbook ansible/playbook.yml --tags base -v --check | tee ansible/logs/ansible.log 

> [!NOTE]
> Probably don't run the install script unless you're me. But, I'm not the boss of you.

The `setup.sh` script installs the necessary dependencies to run the `ansible` playbook. The `ansible` playbook is run separately to configure the development environment in pieces.

## Why Toolbox?

- I was tired of having do extra work to integrate things with my old `fish` setup. 
- Wanted to update some tools and look at new ones.
- Move setup definition to Ansible for better control and organization.
- Possibly look at other tools and configuration management systems.
- Its fun.

### Highlights
- reliable `zsh` configuration, with plugins and utilities covering almost all of what `fish` was doing for me.
- chatbot to interact with the repository via OpenAI Embeddings, LangChain, and Pinecone
- `gencom` to generate commit messages based on currently staged changes (powered by `mods`)

<!-- TODO: source these from the vars file? -->
## Aliases and Commands to Remember

- `CTRL+ff` - fuzzy search for files
- `gaa` - add all files to git
- `ga`  - add files to git interactively with `fzf`
- `gbb` - interactive branch selection with `fzf`
- `gcmsg <message>` - commit with a message
- `gcm` - checkout main branch
- `gcp` - interactive cherry-pick with `fzf`
- `gd`  - interactive git diff with `fzf`
- `gdoof` - add all and amend with no message
- `gll` - count lines in staged git diff
- `glo` - interactive git log with `fzf`
- `goops` - reset last commit soft
- `gss` - interactive stash selection with `fzf`
- `gup` - pull with rebase
- `nett` - show open ports

### General CLI Tools
- `bat` - A modern replacement for `cat`
- `exa` - A modern replacement for `ls`
- `fd` - A modern replacement for `find`
- `forgit` - A `fzf` wrapper for `git` commands
- `fzf` - A fuzzy finder for the command line
- `tldr` - A streamlined `man` page replacement

### Go CLI Tools

- `charm` - A utility to manage `charm` apps
- `freeze` - A tool to take screenshots of code
- `gum` - A tool for glamorous shell scripts
- `mods` - An application to interact with the OpenAI API
- `run` - A utility to run commands in a new shell
- `skate` - A utility to manage secrets
- `vhs` - A tool to create gifs from the terminal
- `wishlist` - An SSH directory app

## Environment Setup and Configuration


### Secrets Helper Script

    $ ./scripts/secrets.sh

This script is designed to streamline setting up secrets in my development environment for this project, but can be generally used to dump secrets from a `skate` database to a local file.

<div align="center">
  <img src="./assets/secrets.gif" width="70%">
</div>


### Playbook

The `playbook.yml` file is the main entry point for the `ansible` configuration. It handles running the roles defined in the `ansible/roles` directory with the variables defined in `config_vars.yml`.

I tend go update this file as needed to configure whatever piece of the environment I'm working on at the time, it's not in a "ready-to-run" state.

### Configuration

`./ansible/config_vars.yml` 
  - Contains configuration variables that define the environment.
  - Things like packages to install, language and tool versions, etc.
  
_environment variables_

`TOOLBOX_DIR`: `~/.toolbox`
  - The directory where the toolbox repository is cloned.

`ANSIBLE_HOME`: `$TOOLBOX_DIR/ansible`
  - Overrides the default ansible home directory.
  
### Ansible Roles

**`base`**
- Installs packages (apt packages on debian/ubuntu) (macports ports on darwin).

**`zsh`**:
- Handles the installation and configuration of `zsh` and `oh-my-zsh`, as well 
  as plugins and utilities.
- Uses `powerlevel10k` for prompt styling.
- Installs `zsh-autosuggestions`, `zsh-completions`, `zsh-syntax-highlighting`,
  `forgit` and `fzf` plugins for enhanced shell functionality.

**`fzf`**:
- Installs `fzf` from git repository.

**`dotfiles`**:
- Symlinks dotfiles in `config_files/` to `$HOME`.

> [!IMPORTANT]
> The `.zshrc` configuration defines a keybinding override to use `^ff` instead of `^t` to trigger `fzf` from the command line.

**`golang`**:

- Handles downloading and installing Golang, along with additional tools and executables.
- Installs `go` under `/usr/local/go`
- Installs executables under `/home/eric/go/bin` <!--is this true?-->
- Install path is defined in `config_vars.yml`
  
### _dev roles

These aren't fully integrated yet, some are just for fun, some are planned to be integrated into the main playbook.

**`ansible-navigator`**

- A text-based user interface (TUI) for Ansible.
- Installed via `pip` as part of the `navigator` role.

**`navi`**

- A command-line cheatsheet tool.

**etc...**
- cleanup: check ownership of files and directories
- hashi: install terraform and packer
- python: install pyenv and pyenv-virtualenv

## Local Git Server

- I'm running a local git server on my network to act as a backup and remote repository 
  for my projects. This repo is setup to mirror to that local server via a 
  post-update hook.

```
#!/bin/bash
# Navigate to the repository
cd /Users/eric/repos/toolbox

# Make sure the local copy is up to date.
git fetch origin

# Push changes to the Soft Serve Git server
git push --mirror local
```
## Links

- [charmbracelet](https://charm.sh/)
- [ansible](https://docs.ansible.com/ansible/latest/index.html)
- [ansible-navigator](https://github.com/ansible/ansible-navigator) |
[docs](https://ansible.readthedocs.io/projects/navigator/)
- [golang](https://golang.org/doc/) | [go installation](https://golang.org/doc/install)
- [forgit](https://github.com/wfxr/forgit)
- [fzf](https://github.com/junegunn/fzf)
- [zsh](https://www.zsh.org/)
- [oh-my-zsh](https://ohmyz.sh/)
- [terraform](https://www.terraform.io/)
- [packer](https://www.packer.io/)

<!-- TODO: add these links -->
- [navi](
- [powerlevel10k](
- [pyenv](
- [pyenv-virtualenv](
