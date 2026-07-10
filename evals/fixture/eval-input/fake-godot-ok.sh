#!/usr/bin/env bash

if [ "${1:-}" = "--version" ]; then
	printf '%s\n' '4.7.stable.fake'
	exit 0
fi

exit 0
