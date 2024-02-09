#!/usr/bin/env bash

arg1="$*" # all text after command
if [ -z "$arg1" ]; then
	echo "Please use \"./upload.sh description of changes\""
	exit 1
fi

echo "Pushing to git..."
git add . >/dev/null
git commit -m "$arg1" >/dev/null
git push || exit
git push github || exit
echo "Pushed with the name: $arg1"
