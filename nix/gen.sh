for f in org/*.org; do
    emacs --batch -l publish.el --eval "(gt/publish \"$f\")"
done
