# 🎭 The "Oh Crap, What Did I Stage?" Script

For the brilliant minds that spawn a million ideas but can't remember which ones they actually worked on.

## 🧠 Why You Need This

- Your brain is a constant fireworks show of ideas
- You've got more half-finished projects than socks
- You regularly find mystery code in your repos

## 🛠 Setup (Even You Can Do This!)

1. Save as `check_staged.sh` (or `what_the_heck_did_i_do.sh` if you're feeling saucy)
2. Make it executable:
   ```
   chmod +x check_staged.sh
   ```
   (This is Unix for "pretty please run")

3. Run it:
   ```
   ./check_staged.sh
   ```
   (Cross your fingers and hope for the best)

## 🎬 The Magic Show

1. Hunts down your Git repos like a caffeinated bloodhound
2. Sniffs out staged changes you forgot about
3. Time-travels to find when you last touched stuff
4. Presents your chaos in a neat, sorted list

## 🎨 Customization (For When You're Feeling Fancy)

Modify the `DIRECTORIES` array. It's like choosing toppings, but for folders:

```bash
DIRECTORIES=(
  "/path/to/directory1"
  "/path/to/directory2"
  # Add or remove directories as needed
)
```

## Troubleshooting

- If you encounter permission errors, ensure you have read access to the specified directories
- For "command not found" errors, verify that Git is installed and in your system PATH