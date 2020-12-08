FROM registry.fedoraproject.org/fedora-minimal:33

RUN microdnf install -y \
    git \
    python3-neovim \
 && microdnf clean all \
 ;

ENV CACHE_BREAK=7

RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
 && chmod u+x nvim.appimage \
 && ./nvim.appimage --appimage-extract \
 && rm nvim.appimage \
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
    rust-src \
    rustfmt \
 && rm rustup.sh \
 ;

RUN curl -LO https://github.com/rust-analyzer/rust-analyzer/releases/download/nightly/rust-analyzer-linux.gz \
 && gunzip rust-analyzer-linux.gz \
 && mv rust-analyzer-linux /usr/bin/rust-analyzer \
 && chmod +x /usr/bin/rust-analyzer \
 ;

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY init5.vim /root/.config/nvim/init.vim
RUN mkdir -p /root/.config/nvim/lua/lspconfig
COPY rust_analyzer.lua /root/.config/nvim/lua/lspconfig/rust_analyzer.lua

RUN echo "alias vi='/squashfs-root/usr/bin/nvim'" >> /root/.bashrc;
RUN ./squashfs-root/usr/bin/nvim +PlugInstall +UpdateRemotePlugins +qa --headless 2> /dev/null
