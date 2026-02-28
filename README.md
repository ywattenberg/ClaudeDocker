# ClaudeDocker

A Docker-based development environment with SSH access, pre-configured with Neovim, Zsh, Tmux, Claude Code, and a curated toolset.

## Default Credentials

| Field    | Value |
|----------|-------|
| Username | `dev` |
| Password | `dev` |

The `dev` user has **passwordless sudo** — you can run `sudo` commands without entering a password.

The SSH password can be changed at build time by passing the `DEV_PASSWORD` build argument:

```bash
docker build --build-arg DEV_PASSWORD=mysecretpassword -t claudedocker .
```

## Quick Start

```bash
docker compose up -d
```

Then connect via SSH on port 2222:

```bash
ssh dev@localhost -p 2222
```

## Build Arguments

| Argument        | Default                                      | Description                          |
|-----------------|----------------------------------------------|--------------------------------------|
| `DEV_PASSWORD`  | `dev`                                        | Password for the `dev` user          |
| `DOTFILES_REPO` | `https://github.com/ywattenberg/dotfiles`    | Git repo to seed the home directory  |

## Included Tools

- **Shell**: Zsh with Starship prompt
- **Editor**: Neovim (latest stable)
- **Multiplexer**: Tmux + TPM
- **Languages**: Node.js 22 LTS, Python 3, C/C++ (clang/clangd/cmake)
- **CLI tools**: GitHub CLI (`gh`), `ripgrep`, `fd`, `uv`, `ruff`, `ty`
- **AI**: Claude Code (`@anthropic-ai/claude-code`)
- **Access**: OpenSSH server (port 22, mapped to 2222 by default)

## Volumes

| Volume          | Mount point          | Purpose                        |
|-----------------|----------------------|--------------------------------|
| `ssh-host-keys` | `/etc/ssh/host_keys` | Persist SSH host keys          |
| `dev-home`      | `/home/dev`          | Persist the dev user's home    |
