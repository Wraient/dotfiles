#!/bin/bash

if [ "$1" == "-e" ]; then
	echo "Edit mode enabled."
	vi $HOME/.config/HyprInsomnia/files.conf
	echo "Config Updated."
	exit
fi


# Set the destination Git repository URL (replace with your URL)
repo_url="github.com/wraient/dotfiles.git"  # Adjust username and repo name
GIT_AUTH_KEY=$(cat /home/$USER/.auth/github_wraient)
dotfile_path="/home/wraient/.hidden/dotfiles"
copy_file_path="/home/wraient/Projects/HyprInsomnia/copy_files.sh"

git config user.email "$USER@$HOST.com"
git config user.name "$USER"
# Temporary variable for authentication key (avoid storing directly in script)

# Function to unset the key after use (security best practice)
function unset_key {
  unset GIT_SSH_KEY
}

resolve_symlink() {
    local path="$1"
    while [ -L "$path" ]; do
        path=$(readlink "$path")
        if [[ $path != /* ]]; then
            path="$(dirname "$1")/$path"
        fi
    done
    echo "$path"
}

# Trap to ensure key unsetting even if script exits prematurely
trap unset_key EXIT

# Ensure Git binary is available
if ! command -v git &> /dev/null; then
  echo "Error: Git is not installed."
  exit 1
fi

resolved_dotfile_path=$(resolve_symlink "$dotfile_path")

# Check if the destination folder (.dotfiles) exists (optional)
if [ ! -d $resolved_dotfile_path ]; then
  echo "Error: The destination path does not exist."
  exit 1
  # echo "Initializing local Git repository..."
fi

echo "Copying config files to HyprInsomnia"
$copy_file_path &> /dev/null

cd $resolved_dotfile_path || exit
# Add all tracked files (if any) and stage them for commit
git add . &> /dev/null  # Suppress output for clean execution

# Commit changes with a descriptive message (replace with your message)
git commit -m "Automatic dotfiles backup - $(date)"
# Push changes to the remote repository using SSH key (avoid storing key directly)
git push https://wraient:$GIT_AUTH_KEY@$repo_url  # Use with caution (force push)

# Unset the temporary key environment variable
unset_key

echo "Dotfiles committed and pushed to remote repository."

