FROM ubuntu:24.04

ARG DEV_PASSWORD=dev

# ---------- locale ----------
RUN apt-get update && apt-get install -y locales \
    && sed -i 's/# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen \
    && locale-gen
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# ---------- system packages ----------
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    zsh git cmake ninja-build gdb clang clangd \
    openssh-server curl wget unzip ripgrep fd-find \
    build-essential python3 python3-venv \
    tmux sudo software-properties-common \
    fontconfig ncurses-term \
    && rm -rf /var/lib/apt/lists/*

# ---------- Node.js 22.x LTS ----------
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# ---------- Neovim (stable from PPA) ----------
RUN add-apt-repository -y ppa:neovim-ppa/stable \
    && apt-get update && apt-get install -y neovim \
    && rm -rf /var/lib/apt/lists/*

# ---------- Nerd Font (JetBrainsMono) ----------
RUN mkdir -p /usr/share/fonts/nerd-fonts \
    && curl -fsSL -o /tmp/JetBrainsMono.zip \
       "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
    && unzip -o /tmp/JetBrainsMono.zip -d /usr/share/fonts/nerd-fonts \
    && rm /tmp/JetBrainsMono.zip \
    && fc-cache -fv

# ---------- Starship prompt ----------
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# ---------- uv, ruff, ty ----------
ENV UV_INSTALL_DIR=/usr/local/bin UV_TOOL_BIN_DIR=/usr/local/bin
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && uv tool install ruff \
    && uv tool install ty

# ---------- Claude Code ----------
RUN npm install -g @anthropic-ai/claude-code

# ---------- user setup ----------
RUN useradd -m -s /usr/bin/zsh -G sudo dev \
    && echo "dev:${DEV_PASSWORD}" | chpasswd

# ---------- SSH server ----------
RUN mkdir -p /run/sshd \
    && sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# ---------- TPM (Tmux Plugin Manager) ----------
RUN git clone https://github.com/tmux-plugins/tpm /home/dev/.config/tmux/plugins/tpm

# ---------- config files ----------
COPY --chown=dev:dev config/zsh/.zshrc            /home/dev/.zshrc
COPY --chown=dev:dev config/zsh/                   /home/dev/.config/zsh/
COPY --chown=dev:dev config/nvim/                  /home/dev/.config/nvim/
COPY --chown=dev:dev config/starship/starship.toml /home/dev/.config/starship.toml
COPY --chown=dev:dev config/tmux/tmux.conf         /home/dev/.config/tmux/tmux.conf

# Ensure ownership of everything in /home/dev
RUN chown -R dev:dev /home/dev

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
