#!/bin/bash

pacman -Qqen > ./pkglist-repo.txt
pacman -Qqem > ./pkglist-aur.txt

chezmoi cd
git add "$HOME/.local/share/chezmoi/scripts/DailyTasks/*"
git commit -m "Updated package list"
git  push -u origin main