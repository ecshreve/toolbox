# toolbox

A collection of tools and configurations for my development environment.

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

### Ansible Roles

I use `ansible` to manage dotfiles and configurations on my system. 
The roles are defined in the `ansible/roles` directory, and the playbook 
`playbook.yml` is responsible for running them.

**`dotfile`**

- Really this role just handles backing up and copying a file. Could be
  generalized later if needed.

**`shell`**

- Installs apt packages.
- Handles the installation and configuration of `zsh` and `oh-my-zsh`, as well 
  as plugins and utilities.

- Configuration for `zsh` is defined in `roles/shell/files/zshrc`, which is 
  copied to `$HOME/.zshrc` after installation. 
  
    > [!IMPORTANT]
    > The `.zshrc` configuration defines a keybinding override to use `^ff` 
    instead of `^t` to trigger `fzf` from the command line.

- Uses `powerlevel10k` for prompt styling.
- Installs `fzf` and `forgit` for fuzzy searching and git integration.
- Installs `zsh-autosuggestions`, `zsh-completions`, `zsh-syntax-highlighting` 
  for enhanced shell functionality.
- Installs `tmux`.

**`golang`**:

- Handles downloading and installing Golang 1.21.8, along with additional tools 
  and executables.
- Installs go under `/usr/local/go`
- Installs executables under `/usr/local/go/bin`
- Install path is defined in `hosts` file under localhost 

### Ansible Tools

#### ansible-navigator

> A text-based user interface (TUI) for Ansible.

Installed via `pip` as part of the `shell` role.

[repo](https://github.com/ansible/ansible-navigator) |
[docs](https://ansible.readthedocs.io/projects/navigator/)

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

## Ongoing

todo
- [ ] refactor playbook vars
- [ ] play around with tmux config
- [-] figure out copy/paste from cli
- [x] write docs for assistant
- [ ] helper scripts
- [ ] fzf run tasks helper
- [ ] move config values out of playbook
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
