#  toolbox 

A collection of tools and configurations for my development environment.


## Current Status

- MacOS 13.0 / Ubuntu 22.04.
- Go: 1.22.2
- Python: 3.12.2

### Why Toolbox?

- I was tired of having do extra work to integrate things with my old `fish` setup. 
- Time to update some tools and look at new ones.
- Wanted to move to ansible for configuration management rather than rely on just an install script and the VSCode dotfiles settings.
- Its fun.

### Highlights
- reliable `zsh` configuration, with plugins and utilities covering almost all of what `fish` was doing for me.
- `mods` configuration to interact with AI models from CLI 
- chatbot to interact with the repository via OpenAI Embeddings, LangChain, and Pinecone
- `gencom` to generate commit messages based on currently staged changes (powered by `mods`)
  

## Toolbox Chat

Toolbox Chat is a Streamlit-based web application designed to facilitate interactive conversations powered by LangChain and OpenAI's GPT models.

It is integrated with Pinecone, a vector database, and LangChain's information retrieval tools to provide a conversational interface to the contents of the repository itself.

<div align="center">
  <img src="./assets/toolchat.png" width="70%">
</div>

<br>
See the [assistant README](assistant/README.md) for more information.

## Environment Setup and Configuration

### Install script

- Checks the TOOLBOX_PATH environment variable
- Installs `python3` and `pip` via `apt`
- Installs ansible via `pip`
- Clones this repository to `$HOME/.toolbox`
- Runs the `ansible` playbook

> [!NOTE]
> Probably don't run the install script unless you're me. But, I'm not the boss of you.

### Playbook

The `playbook.yml` file is the main entry point for the `ansible` configuration. It handles running the roles defined in the `ansible/roles` directory with the variables defined in `config_vars.yml`.

The playbook can be run with the following command to  see the output in the terminal and log it to a file:

    $ ansible-playbook playbook.yml -v | tee ansible/logs/ansible.log

With ansible-navigator installed, the playbook can be run with the following command to open the TUI:

    $ ansible-navigator run playbook.yml -v 

### Configuration

`./config_vars.yml` 
  - Contains the variables used in `playbook.yml`.
  - Things like packages to install, language and tool versions, etc
  
`ansible/hosts` 
  - Defines the `localhost` host and some specific variables related to the env
  - This file only contains the `localhost` host, as all roles are run locally.
  
### Ansible Roles

For environment setup `ansible` is used to manage dotfiles and configurations. 
The roles are defined in the `ansible/roles` directory, and the playbook 
`playbook.yml` is responsible for running them.

**`shell`**

- Installs apt packages (macports ports on darwin).
- Handles the installation and configuration of `zsh` and `oh-my-zsh`, as well 
  as plugins and utilities.
- Configuration for `zsh` is defined in `roles/shell/files/zshrc`, which is 
  copied to `$HOME/.zshrc` after installation. 
- Uses `powerlevel10k` for prompt styling.
- Installs `fzf` and `forgit` for fuzzy searching and git integration.
- Installs `zsh-autosuggestions`, `zsh-completions`, `zsh-syntax-highlighting` 
  for enhanced shell functionality.
- Installs `tmux`.
- Copies dotfiles to home directory

> [!IMPORTANT]
> The `.zshrc` configuration defines a keybinding override to use `^ff` instead of `^t` to trigger `fzf` from the command line.



**`golang`**:

- Handles downloading and installing Golang 1.22.2, along with additional tools 
  and executables.
- Installs go under `/usr/local/go`
- Installs executables under `/usr/local/go/bin`
- Install path is defined in config_vars.yml

### Ansible Tools

**`ansible-navigator`**

- A text-based user interface (TUI) for Ansible.
- Installed via `pip` as part of the `navigator` role.

### General CLI Tools

- `exa` - A modern replacement for `ls`
- `bat` - A modern replacement for `cat`
- `fd` - A modern replacement for `find`
- `fzf` - A fuzzy finder for the command line
- `forgit` - A `fzf` wrapper for `git` commands
- `tldr` - A streamlined `man` page replacement

### Go CLI Tools
- `run` - A utility to run commands in a new shell
- `skate` - A utility to manage secrets
- `charm` - A utility to manage `charm` apps
- `mods` - An application to interact with the OpenAI API
- `gum` - A tool for glamorous shell scripts
- `freeze` - A tool to take screenshots of code
- `wishlist` - An SSH directory app

## Ideas

todo
- [x] refactor playbook vars
- [ ] play around with tmux config
- [-] figure out copy/paste from cli
- [x] write docs for assistant
- [ ] helper scripts
- [ ] fzf run tasks helper
- [x] move config values out of playbook
- [x] python environment setup
- [ ] add mods roles and helper scripts
- [x] upgrade to go 1.22
- [ ] handle vscode config file

maybe
- [ ] Add `soft serve` git server
- [ ] Add `run` configuration
- [ ] Use `skate` to handle secrets
- [ ] Bake all of this into a docker image

done
- [x] Take a few cycles to clean up the `golang` role.
- [x] Audit .yml vs ~~.yaml~~ file extensions
- [x] Add `tmux` configuration
- [x] Add `aliases` to .zshrc
- [x] Configure `charm` server to run via docker

## Links

- [charmbracelet](https://charm.sh/)
- [ansible](https://docs.ansible.com/ansible/latest/index.html)
- [ansible-navigator](https://github.com/ansible/ansible-navigator) |
[docs](https://ansible.readthedocs.io/projects/navigator/)
- [golang](https://golang.org/doc/) | [go installation](https://golang.org/doc/install)