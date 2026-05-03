#!/usr/bin/env bash

set -euo pipefail

SOURCE_PATH="$1"
TARGET_PATH="$2"
[ -z "$SOURCE_PATH" ] && { echo "No configuration source directory provided."; exit 1; }
[ -d "$SOURCE_PATH" ] || { echo "Could not find configuration source directory '$SOURCE_PATH'."; exit 1; }
[ -z "$TARGET_PATH" ] && { echo "No configuration target directory provided."; exit 1; }
[ -d "$TARGET_PATH" ] || { echo "Could not find configuration target directory '$TARGET_PATH'."; exit 1; }
MERGE_PATH="$SOURCE_PATH/.merged"
mkdir -p "$MERGE_PATH"

for moduleSrcPath in "$SOURCE_PATH/"*; do
    [ ! -d "$moduleSrcPath" ] && continue
    echo "Merging configuration provided by '$(basename "$moduleSrcPath")' module..."
    (
        cd "$moduleSrcPath"
        find . -name '*.yml' -type f -printf '%P\n' | while read -r cfgRelFilePath; do
            echo "Merging '$cfgRelFilePath'"
            cfgRelDirPath="$(dirname "$cfgRelFilePath")"
            [ "$cfgRelDirPath" == "." ] && cfgRelDirPath=""
            mkdir -p "$MERGE_PATH/$cfgRelDirPath"
            touch "$MERGE_PATH/$cfgRelFilePath"
            # shellcheck disable=SC2016 # $item variable is part of yq expression and not to be expanded
            yq eval-all '. as $item ireduce ({}; . * $item )' "$MERGE_PATH/$cfgRelFilePath" "$cfgRelFilePath"
        done
    )
    echo "Evaluating priorities..."
    (
        cd "$MERGE_PATH"
        find . -name '*.yml' -type f -printf '%P\n' | while read -r cfgRelFilePath; do
            cfgRelDirPath="$(dirname "$cfgRelFilePath")"
            cfgFileName="$(basename -- "$cfgRelFilePath")"
            cfgFileExtension="${cfgFileName##*.}"
            cfgFileBaseName="${cfgFileName%.*}"
            cfgFilePriority="${cfgFileBaseName##*.}"
            if ! [[ "$cfgFilePriority" =~ ^hbtprio-[0-9]+$ ]] || [ "$cfgFilePriority" == "$cfgFileBaseName" ]; then
                continue
            fi
            cfgFileBaseName="${cfgFileBaseName%.*}"
            cfgFilePriority="${cfgFilePriority##hbtprio-}"
            cfgFilePriority="$(( cfgFilePriority + 0 ))"
            echo "Merging '$cfgRelFilePath' into '$cfgRelDirPath/$cfgFileBaseName.$cfgFileExtension'"
        done
    )
done

echo "Copying final configuration to '$TARGET_PATH'"
cp -rp "$MERGE_PATH" "$TARGET_PATH"

exit 0