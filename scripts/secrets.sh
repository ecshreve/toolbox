#!/usr/bin/env bash

# This script uses Gum to fetch secrets from a Skate database and writes them to
# an environment file. It prompts the user for the database name and the
# environment file name. If the environment file already exists, it creates a
# backup of the file before overwriting it.

set -e

# Check for the presence of required commands: gum and skate.
for cmd in gum skate; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "$cmd command not found. Exiting."
        exit 1
    fi
done

help() {
    cat <<EOF
Usage: secrets.sh

This script fetches secrets from a Skate database and writes them to an
environment file. It prompts the user for the database name and the environment
file name. If the environment file already exists, it creates a backup of the
file before overwriting it.

Options:
  -h, --help  Show this help message and exit.

EOF
}

# Parse command-line arguments.
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            help
            exit 1
            ;;
    esac
done

# Log helper function for structured debug logging.
slog() {
    gum log \
        --time rfc822 \
        --structured \
        --level debug "$@"
}

# Prompt user for the database name, with a default suggestion.
DB_NAME=$(gum input --value "mytoolboxsecrets.db" \
                    --prompt.foreground "#0FF" \
                    --prompt "db_name: ")
slog "Selected database" db "$DB_NAME"

slog "Reloading database..."
gum spin --title "reloading db..." -- skate reset @"$DB_NAME"

# Prompt user for the environment file name, with a default suggestion.
ENV_FILE=$(gum input --value ".env.skate" \
                     --prompt.foreground "#0FF" \
                     --prompt "env_file: ")
slog "Selected env file" file "$ENV_FILE"

slog "Checking if file exists"
if [[ -f "$ENV_FILE" ]]; then
    slog "File already exists, creating a backup."
    cp "$ENV_FILE" "$ENV_FILE.bak"
fi

slog "Getting secrets..."
gum spin --show-output --title "getting secrets..." \
         -- skate list @"$DB_NAME" | \
    awk -v OFS='=' '{print "export", toupper($1), $2}' > "$ENV_FILE"

slog "Secrets written to $ENV_FILE"

slog "Done"
