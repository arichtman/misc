#!/bin/bash

sudo cp podman /etc/init.d/
sudo chmod +x /etc/init.d/podman

sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.11 python3.11-distutils python3.11-dev

curl -sSL https://install.python-poetry.org | python3 -

poetry config virtualenvs.in-project true


git config --global init.templateDir ~/.git-template
pre-commit init-templatedir ~/.git-template
