#!/usr/bin/env bash

FROM="$1"
TO="$2"
echo "--- Creating GitHub draft release from $FROM to $TO ..."

FILE=release_github.md

echo "
Pull Request merged between $FROM & $TO

---

| PR      | Title   | By | Date     |
| :---    | :---   | :--- | :--- |" > "$FILE"

SEARCH_PATTERN="Merge pull request"
git log --merges\
 "$FROM...$TO"\
 --grep "$SEARCH_PATTERN"\
 --pretty=format:"| %s __end_subject__ | %b | %an | %cs | " \
| sed "s/$SEARCH_PATTERN//"\
| sed "s/from.*__end_subject__//g"\
>> "$FILE"

echo "" >> $FILE

SEARCH_PATTERN="Merge branch '$TO' into"
git log --merges\
 "$FROM...$TO"\
 --pretty=format:"| %s | %b | %an | %cs | " \
 --grep "$SEARCH_PATTERN"\
| sed "s/$SEARCH_PATTERN//"\
| sed "s/issue-/#/"\
| sed "1,$ s/-/ | /"\
| sed "s/|  |/ | /"\
>> "$FILE"


##create draft release
NEW_VERSION=v$(date +%F_%H%M)
gh release create "$NEW_VERSION"\
  -F "$FILE"\
  --title "$NEW_VERSION"\
  --draft

rm $FILE
