#!/usr/bin/env bash
selected=`cat ~/.config/tmux/tmux-cht-languages ~/.config/tmux/tmux-cht-command | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.config/tmux/tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    tmux respawn-pane -k bash -c -u "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux respawn-pane -k bash -c "curl -s cht.sh/$selected~$query | less"
fi
