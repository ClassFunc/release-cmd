#!/usr/bin/env bash

FROM="$1"
TO="$2"
echo "Creating GitHub draft release from $FROM to $TO ..."

FILE=release_github.md
#echo "$COMPARE"
echo "
Pull Request merged between $FROM & $TO

---

| PR      | Title   | By | Date     |
| :---    | :---   | :--- | :--- |" > "$FILE"

git log --merges\
 "$FROM...$TO"\
 --grep 'Merge pull request'\
 --pretty=format:"| %s __end_subject__ | %b | %an | %cs | " \
| sed "s/Merge pull request//"\
| sed "s/from.*__end_subject__//g"\
>> "$FILE"


##create draft release
NEW_VERSION=v$(date +%F_%H%M)
gh release create "$NEW_VERSION"\
  -F "$FILE"\
  --title "$NEW_VERSION"\
  --draft

echo "created file: $FILE"
