FROM fedora:32

RUN curl -sSL \
  --location https://dl.yarnpkg.com/rpm/yarn.repo \
  | tee /etc/yum.repos.d/yarn.repo

RUN dnf install -y \
 ShellCheck \
 fd-find \
 # gcc \
 git \
 # make \
 neovim \
 nodejs \
 python-pip \
 ripgrep \
 yarn \
 && dnf clean all \
 ;

COPY init.vim /root/.config/nvim/
COPY coc-settings.json /root/.config/nvim/

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim +'PlugInstall' +qa --headless

RUN pip install --no-cache \
    black \
    jedi \
    pep8 \
    pylint \
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
    clippy \
 && rm rustup.sh \
 ;

RUN curl -LO https://github.com/rust-analyzer/rust-analyzer/releases/download/nightly/rust-analyzer-linux.gz \
 && gunzip rust-analyzer-linux.gz \
 && mv rust-analyzer-linux /usr/bin/rust-analyzer \
 && chmod +x /usr/bin/rust-analyzer \
 ;

RUN echo "alias vi='nvim'" >> /root/.bashrc;
