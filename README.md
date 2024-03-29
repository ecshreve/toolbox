# toolbox

## Todo

- [ ] Add `docker` role
- [ ] Add `aliases` to .zshrc
- [ ] Configure `charm` server to run via docker, back it up to NAS
- [ ] Use `skate` to handle secrets
- [ ] Bake all of this into a docker image

## Usage

```shell
$ cd /path/to/toolbox
$ ./install.sh
$ cd ansible && ansible-playbook main.yml
```

## Ansible Roles

### `term`

Handles initial basic setup of terminal environment. The tasks in this role
prepare to use ansible to install and configure the rest of the environment.

- python3 and pip
- ansible and ansible-lint
- zsh and oh-my-zsh
- zsh plugins; most importantly fzf and forgit

### `go`

- Go 1.21.8
- A handful of go tools
