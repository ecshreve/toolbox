#  toolbox 

A collection of tools, configuration files, notes, and scripts.

Used to manage development environment(s) and tools across machines, operating systems, containers, and virtual machines.

## Usage

During active development I run the `ansible` playbook either locally or in a container to configure my development environment.

Most often the setup script runs in a Ubuntu docker container on my macbook during the build of a Coder workspace. It is called by the coder agent's startup_script.

```hcl
resource "coder_agent" "main" {
  arch           = data.coder_provisioner.me.arch
  os             = "linux"
  startup_script = <<-EOT
    set -e
    ...
    
    echo "Installing toolbox dotfiles..."
    coder dotfiles -y https://github.com/ecshreve/toolbox.git
    
    ...
    echo "Done."
  EOT
```


> [!NOTE]
> Probably don't run the install script, it does a lot of things.


## Highlights / Fun Stuff
- reliable `zsh` configuration, with plugins and utilities covering almost all of what `fish` was doing for me.
- chatbot to interact with the repository via OpenAI Embeddings, LangChain, and Pinecone
- `gencom` to generate commit messages based on currently staged changes (powered by `mods`)

<!-- TODO: source these from the vars file? -->
### Aliases and Commands to Remember

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

## Ansible

### Playbook

The `playbook.yml` file is the main entry point for the `ansible` configuration. It handles running the roles defined in the `ansible/roles` directory with the variables defined in `config_vars.yml`.

### Variables

`./ansible/config_vars.yml` 
  - Contains configuration variables defining packages to install, versions, and paths to target, among other things.
  
### Roles

**`base`**
- Determines the operating system and package manager.
- Install packages (apt-get on debian/ubuntu) (brew on darwin/macos).

**`zsh`**:
- Install and configure of `zsh` and `oh-my-zsh`, plugins, and utilities.
  - `zsh-autosuggestions`, `zsh-completions`, `zsh-syntax-highlighting`, `forgit` and `fzf` plugins for enhanced shell functionality.
  - `powerlevel10k` for prompt styling.

**`fzf`**:
- Install `fzf` from git repository.

**`gitenv`**:
- Symlink `git` configuration files in `config_files/` to `$HOME`.

**`dotfiles`**:
- Symlink shell configuration files in `config_files/` to `$HOME`.

> [!IMPORTANT]
> The `.zshrc` configuration defines a keybinding override to use `^ff` instead of `^t` to trigger `fzf` from the command line.
  
### _dev roles

These aren't fully integrated or tested yet, some are just for fun.

**`golang`**:

- Handles downloading and installing Golang, along with additional tools and executables.
- Installs `go` under `/usr/local/go`
- Installs executables under `/home/eric/go/bin` <!--is this true?-->
- Install path is defined in `config_vars.yml`

**`ansible-navigator`**

- A text-based user interface (TUI) for Ansible.
- Installed via `pip` as part of the `navigator` role.

**`navi`**

- A command-line cheatsheet tool.

**etc...**
- cleanup: check ownership of files and directories
- hashi: install terraform and packer
- python: install pyenv and pyenv-virtualenv

## Coder

### Devbox Template

The `coder/templates/devbox` directory contains a template for setting up a Coder workspace with the `toolbox` configuration. I'm currently running workspaces locally and occasionally on a DigitalOcean droplet.

### Secrets Helper Script

    $ ./scripts/secrets.sh

This script is designed to streamline setting up secrets in my development environment for this project, but can be generally used to dump secrets from a `skate` database to a local file.

<div align="center">
  <img src="./assets/secrets.gif" width="70%">
</div>


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
