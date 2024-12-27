#!/bin/bash

pacman -Qqen > /home/malenia/.local/share/chezmoi/scripts/DailyTasks/pkglist-repo.txt
pacman -Qqem > /home/malenia/.local/share/chezmoi/scripts/DailyTasks/pkglist-aur.txt

cd /home/malenia/.local/share/chezmoi
git add "$HOME/.local/share/chezmoi/scripts/DailyTasks/*"
git commit -m "Updated package list"
git  push -u origin main