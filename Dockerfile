FROM registry.fedoraproject.org/fedora-minimal:33

RUN microdnf install -y \
    ShellCheck \
    fd-find \
    fzf \
    git \
    neovim \
    nodejs \
    ripgrep \
 && microdnf clean all \
 ;

ENV RUSTUP_HOME=/root/rustup \
    CARGO_HOME=/root/cargo \
    PATH=/root/cargo/bin:$PATH \
    RUST_SRC_PATH=/root/rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src \
    USER=root

RUN curl -f -L https://static.rust-lang.org/rustup.sh -O \
 && sh rustup.sh -y \
    --no-modify-path \
    --profile minimal \
 && rustup default stable \
 && rustup component add \
    rustfmt \
 && rm rustup.sh \
 ;

RUN pip install --upgrade \
  pynvim \
  black \
  ;

RUN curl -fLo /usr/bin/shfmt https://github.com/mvdan/sh/releases/download/v3.2.2/shfmt_v3.2.2_linux_amd64 && chmod +x /usr/bin/shfmt

RUN curl -fLo /root/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY init.vim /root/.config/nvim/init.vim
COPY coc-settings.json /root/.config/nvim/coc-settings.json

RUN ln -s /usr/bin/nvim /usr/bin/vi
RUN nvim +PlugInstall +UpdateRemotePlugins +qa --headless 2> /dev/null

