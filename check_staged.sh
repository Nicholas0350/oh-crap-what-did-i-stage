#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# Define the directories to search
DIRECTORIES=("$FILE_PATH_A" "$FILE_PATH_B")

echo "Searching in directories: ${DIRECTORIES[*]}"

# Initialize an array to store repositories with recent commits
declare -a recent_repos

# Set the time frame for recent commits to 30 days
SINCE="30 days ago"

for BASE_DIR in "${DIRECTORIES[@]}"; do
    # Find all directories containing a .git folder within the specified path
    while IFS= read -r -d '' repo; do
        repo_dir=$(dirname "$repo")
        repo_name=$(basename "$repo_dir")
        cd "$repo_dir" || continue

        # Check for recent commits
        if [ -n "$(git log --since="$SINCE" --format="%H")" ]; then
            # Get the last commit date for the repository
            commit_date=$(git log -1 --format="%at")
            recent_repos+=("$commit_date|$repo_name")
        fi

    done < <(find "$BASE_DIR" -type d -name ".git" -print0 2>/dev/null)
done

# Sort and display the repositories with recent commits
if [ ${#recent_repos[@]} -eq 0 ]; then
    echo "No repositories with commits in the last 30 days found."
else
    echo "Repositories with commits in the last 30 days (sorted by most recent commit):"
    printf "%s\n" "${recent_repos[@]}" | sort -rn | uniq | while IFS='|' read -r time repo; do
        echo "$(date -r "$time" "+%Y-%m-%d %H:%M:%S") - $repo"
    done
fi