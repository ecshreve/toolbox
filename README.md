#  toolbox 

A collection of tools and configurations for my development environment.

I use this repository to manage my development environment across different machines, operating systems, containers, and cloud workspaces. The repository is designed to be cloned and run on a Ubuntu or MacOS system (only tested on my computers, ymmv).

## Usage

Besides installation on a local machine, I use this repository to build a ubuntu based docker image with tools installed. The devcontainer for this repository is based on _that_ custom image. And both the vanilla docker image and the devcontainer are built via a github action, and pushed to the github container registry.


### Codespaces

[![Latest Image](https://ghcr-badge.egpl.dev/ecshreve/toolbox/latest_tag?color=%2344cc11&ignore=latest&label=latest&trim=)](https://github.com/ecshreve/toolbox/pkgs/container/toolbox/203676976?tag=latest)

Prebuilt devcontainer for the latest image in the github container registry.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ecshreve/toolbox?devcontainer_path=.devcontainer%2Ftoolbox-prod%2Fdevcontainer.json)


>[!NOTE]
>Open a `zsh` shell in the terminal to get started. Regardless of the default profile, codespaces opened in the web client always open with a bash session running initially.

### Local

To run the `toolbox` setup locally, clone the repository and run the `install.sh` script:

    $ git clone https://github.com/ecshreve/toolbox.git ~/.toolbox

    $ cd ~/.toolbox

    $ ./install.sh

The script will check the necessary dependencies and run the `ansible` playbook to configure the environment.

## Why Toolbox?

- I was tired of having do extra work to integrate things with my old `fish` setup. 
- Time to update some tools and look at new ones.
- Wanted to move to ansible for configuration management rather than rely on just an install script and the VSCode dotfiles settings.
- Its fun.

### Highlights
- reliable `zsh` configuration, with plugins and utilities covering almost all of what `fish` was doing for me.
- `mods` configuration to interact with AI models from CLI 
- chatbot to interact with the repository via OpenAI Embeddings, LangChain, and Pinecone
- `gencom` to generate commit messages based on currently staged changes (powered by `mods`)
- devcontainer prebuilt and ready for toolbox installation

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

## Toolbox Chat

Toolbox Chat is a Streamlit-based web application designed to facilitate interactive conversations powered by LangChain and OpenAI's GPT models.

It is integrated with Pinecone, a vector database, and LangChain's information retrieval tools to provide a conversational interface to the contents of the repository itself.

<div align="center">
  <img src="./assets/toolchat.png" width="70%">
</div>

<br>
See the [assistant README](assistant/README.md) for more information.

## Environment Setup and Configuration

### Install Script

> [!NOTE]
> Probably don't run the install script unless you're me. But, I'm not the boss of you.

The `install.sh` script is a wrapper around the `ansible-playbook` command that runs the `playbook.yml` file with the `config_vars.yml` file as input. The script is responsible for setting up the environment, checking prerequisites and requirements, parsing cli options, and finally running the playbook.

[usage](#usage)

### Secrets Helper Script

    $ ./scripts/secrets.sh

This script is designed to streamline setting up secrets in my development environment for this project, but can be generally used to dump secrets from a `skate` database to a local file.

<div align="center">
  <img src="./assets/secrets.gif" width="70%">
</div>


### Playbook

The `playbook.yml` file is the main entry point for the `ansible` configuration. It handles running the roles defined in the `ansible/roles` directory with the variables defined in `config_vars.yml`.

The playbook can be run with the following command to  see the output in the terminal and log it to a file:

    $ ansible-playbook playbook.yml -v | tee ansible/logs/ansible.log

With ansible-navigator installed, the playbook can be run with the following command to open the TUI:

    $ ansible-navigator run playbook.yml -v 

[ansible-navigator-role](#_beta-roles)
### Configuration

`./config_vars.yml` 
  - Contains the variables used in `playbook.yml`.
  - Things like packages to install, language and tool versions, etc
  
_environment variables_

`TOOLBOX_DIR`: `~/.toolbox`
  - The directory where the toolbox repository is cloned.

`ANSIBLE_CONFIG_DIR`: `$TOOLBOX_DIR/ansible/ansible.cfg`
  - The file where the toolbox ansible configuration is stored.
  - 
### Ansible Roles

For environment setup `ansible` is used to manage dotfiles and configurations. 
The roles are defined in the `ansible/roles` directory, and the playbook 
`playbook.yml` is responsible for running them.

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

- Handles downloading and installing Golang, along with additional tools 
  and executables.
- Installs `go` under `/usr/local/go`
- Installs executables under `/home/eric/go/bin`
- Install path is defined in `config_vars.yml`
  
### _dev roles

These aren't fully integrated yet, some are just for fun, some are planned
to be integrated into the main playbook.

**`ansible-navigator`**

- A text-based user interface (TUI) for Ansible.
- Installed via `pip` as part of the `navigator` role.

**`navi`**

- A command-line cheatsheet tool.

**etc...**
- cleanup: check ownership of files and directories
- hashi: install terraform and packer
- python: install pyenv and pyenv-virtualenv

## CI/CD

[![Combined CI](https://github.com/ecshreve/toolbox/actions/workflows/ci.yml/badge.svg?event=release)](https://github.com/ecshreve/toolbox/actions/workflows/ci.yml)
[![Latest Image](https://ghcr-badge.egpl.dev/ecshreve/toolbox/latest_tag?color=%2344cc11&ignore=latest&label=latest&trim=)](https://github.com/ecshreve/toolbox/pkgs/container/toolbox/203676976?tag=latest)
[![Image Size](https://ghcr-badge.egpl.dev/ecshreve/toolbox/size?color=%2344cc11&tag=latest&label=image+size&trim=)](https://github.com/ecshreve/toolbox/pkgs/container/toolbox)



### Docker Image

The `Dockerfile` in the root of the repository is used to build a docker image with the tools and configurations defined in the `ansible` playbook. The image is built and pushed to the github container registry via a github action.

The image is based on `ubuntu:22.04`, first installs some core packages and tools via `apt` and `pip`, then runs the ansible playbook which handles the rest of the setup.

### Devcontainer

The `devcontainer.json` file in the `.devcontainer` directory is used to define the devcontainer for this repository. The devcontainer is based on the custom docker image built from the `Dockerfile` in the root of the repository. The devcontainer defined in `.devcontainer/toolbox-prod/devcontainer.json` is based on pulling the prebuilt image from the github container registry, and is an example of how to use the devcontainer in another repository.

The `toolbox_prod` devcontainer is also used as the source for the codespaces prebuild configuration.

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
