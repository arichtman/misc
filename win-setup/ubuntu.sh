#!/bin/bash

sudo cp podman /etc/init.d/
sudo chmod +x /etc/init.d/podman

sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python

curl -sSL https://install.python-poetry.org | python3 -

poetry config virtualenvs.in-project true
