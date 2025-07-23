#!/usr/bin/env bash

# check luacheck
if ! which luacheck > /dev/null; then
    echo "WARNING: Could not run luacheck"
    echo "Please install luacheck first: "${TADPOLE_DIR:-./tadpole}"/misc/scripts/install-luarocks.sh"
    exit 1
fi

# lua_files=$(git status -s|awk '{if (($1=="M"||$1=="A") && $2 ~ /.lua$/)print $2;}')
lua_files=$(git diff --cached --name-only --diff-filter=AM|grep -e .lua$)

if [[ "$lua_files" != "" ]]; then
    result=$(luacheck $lua_files)
    if [[ "$result" =~ .*:.*:.*: ]]; then
        echo "$result"
        echo ""
        exec < /dev/tty
        read -p "Are you sure to commit? (N/Y)"
        if [[ "$REPLY" == n* ]] || [[ "$REPLY" == N* ]] || [[ "$REPLY" == "" ]]; then
            echo "Abort commit"
            exit 1
        fi
    fi
fi
