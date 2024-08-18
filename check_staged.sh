#!/bin/bash

# Define the directories to search
DIRECTORIES=("/file/path" "/file/path")

# Initialize an array to store all the staged changes
staged_changes=()

for BASE_DIR in "${DIRECTORIES[@]}"; do
    # Find all directories containing a .git folder within the specified path, suppressing errors
    repos=$(find "$BASE_DIR" -type d -name ".git" 2>/dev/null)

    # Check if any repositories were found
    if [ -z "$repos" ]; then
        echo "No Git repositories found in $BASE_DIR."
        continue
    fi

    for repo in $repos; do
        # Navigate to the repository's directory
        repo_dir=$(dirname "$repo")
        cd "$repo_dir" || continue

        # Check for staged changes and store them in the array
        if ! git diff --cached --quiet; then
            changes=$(git diff --cached --name-only)
            for change in $changes; do
                full_path="$repo_dir/$change"
                mod_time=$(stat -f "%m" "$full_path") # Get modification time (Unix timestamp)
                staged_changes+=("$mod_time $full_path")
            done
        fi
    done
done

# Sort by modification time and display the staged changes
if [ ${#staged_changes[@]} -eq 0 ]; then
    echo "No staged changes found in the specified directories."
else
    echo "Staged changes (sorted by most recent):"
    printf "%s\n" "${staged_changes[@]}" | sort -n | awk '{print $2}' # Sort by timestamp and display
fi


# run chmod +x check_staged.sh
# then run ./check_staged.sh