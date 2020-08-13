# nvim-container

neovim in a container with coc all setup to work with rust and python.

## Usage

### Build

```bash
docker build -t casonadams/vi .
```

### Run in bash

```bash
docker run -v $(pwd):/p:z -it casonadams/vi bash
```

### Setup to run from anywhere

TODO: Need to get this figured out for now

```bash
cp ide /usr/local/bin
```

```bash
cd /some/project
ide
```
