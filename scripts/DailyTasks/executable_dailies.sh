#!/bin/bash

pacman -Qqen > ./pkglist-repo.txt
pacman -Qqem > ./pkglist-aur.txt