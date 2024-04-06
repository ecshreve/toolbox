#!/bin/bash

# Navigate to the root of the Git repository
repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

# Check if the mods commands are available
for cmd in mods gum; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "The $cmd command is not available. Make sure it is installed and in your PATH."
        exit 1
    fi
done

# Check if env vars are set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "OPENAI_API_KEY is not set, can't generate commit message."
    exit 1
fi

# Check if there are too many changes to commit
DIFF_LINES=$(git diff --cached | wc -l)
if [ "$DIFF_LINES" -lt 1 ]; then
    echo "No changes staged commit."
    exit 1
elif [ "$DIFF_LINES" -gt 500 ]; then
    echo "Too many changes to send to mods. Please commit fewer changes at a time."
    exit 1
fi

# Check if the mods.yml file exists, if not, create it.
if [ ! -f mods.yml ]; then
    echo "mods.yml not found, creating it."
    cp /workspaces/toolbox/config_files/mods.yml $HOME/.config/mods/mods.yml
fi

# Generate the commit message using mods, displays a spinner until mods finishes.
OUT=$(gum spin --spinner line --show-output --title "generating commit..." -- bash -c 'git diff --cached | mods --role gencom')

# Display the commit message in a gum dialog with a border and rulers marking
# where 50 and 72 characters are.
gum style --border double --margin "1" --padding "1 1" --border-foreground 35 --width 80 "$OUT"

# User chooses to commit immediately as is and exit, or to edit.
gum confirm "commit?" && git commit -m "$OUT" && exit 0

# User chooses to edit the commit message, or to exit.
gum confirm "edit?" && git commit -m "$OUT" --edit && exit 0

# If we reach this point, the user chose to exit without committing.
echo "exiting without commit"

