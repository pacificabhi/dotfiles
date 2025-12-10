configs=("nvim" "hypr" "waybar" "tmux" "sway")

for c in "${configs[@]}"; do
  if [ -d "$c" ]; then
    echo "copying $c"
    cp -r "$HOME/.config/$c" .
  else
    echo "$c not found"
  fi
done

echo "copying zsh"
cp $HOME/.zshrc ./zsh/
