#!/usr/bin/env bash

if [ "${1:-}" = "--version" ]; then
	printf '%s\n' '4.7.stable.fake'
	exit 0
fi

for arg in "$@"; do
	if [ "$arg" = "res://scripts/player.gd" ]; then
		printf '%s\n' 'Parse Error: intentional fixture failure'
		exit 1
	fi
done

exit 0
