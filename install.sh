#!/usr/bin/env bash

if [ -f ./.devbox ]
then
    echo "Devbox already installed."
    exit 0
fi

touch ./.devbox
vagrant plugin install vagrant-reload

if [ ! -d ../www ]
then
    mkdir ../www/
fi

vagrant up