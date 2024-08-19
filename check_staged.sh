#!/bin/bash

# Define the directories to search
DIRECTORIES=(FILE_PATH_A, FILE_PATH_B)

# Initialize an array to store all the staged changes
declare -a staged_changes

for BASE_DIR in "${DIRECTORIES[@]}"; do
    # Find all directories containing a .git folder within the specified path
    while IFS= read -r -d '' repo; do
        repo_dir=$(dirname "$repo")
        cd "$repo_dir" || continue

        # Check for staged changes
        while IFS= read -r change; do
            full_path="$repo_dir/$change"
            if [[ -f "$full_path" ]]; then
                # Get the last commit date for the file
                commit_date=$(git log -1 --format="%at" -- "$change")
                staged_changes+=("$commit_date|$full_path")
            fi
        done < <(git diff --cached --name-only)

    done < <(find "$BASE_DIR" -type d -name ".git" -print0 2>/dev/null)
done

# Sort and display the staged changes
if [ ${#staged_changes[@]} -eq 0 ]; then
    echo "No staged changes found in the specified directories."
else
    echo "Staged changes (sorted by most recent commit):"
    printf "%s\n" "${staged_changes[@]}" | sort -rn | while IFS='|' read -r time path; do
        echo "$(date -r "$time" "+%Y-%m-%d %H:%M:%S") - $path"
    done
fi

# Run:
# chmod +x check_staged.sh
# Then Run
# ./check_staged.sh