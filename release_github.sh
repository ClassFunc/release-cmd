# tham khao:
# https://github.com/github/hub/issues/2118,
# https://stackoverflow.com/questions/8136178/git-log-between-tags

 # shellcheck disable=SC2046
# clear
FROM_TAG=$(git describe --tags --abbrev=0)
echo "from tag or branch ($FROM_TAG): \c"
read -r from_tag
[ -n "$from_tag" ] && FROM_TAG=$from_tag
#echo "$FROM_TAG"

TO_TAG=$(git branch --show-current)
echo "to tag or branch ($TO_TAG): \c"
read -r to_tag
[ -n "$to_tag" ] && TO_TAG=$to_tag

COMPARE="$FROM_TAG...$TO_TAG"

FILE=release_github.md
#echo "$COMPARE"
echo -e "Updated $COMPARE \n ---" > "$FILE"

LOG=$(git log --merges\
 "$COMPARE"\
 --grep 'Merge pull request'\
 --pretty=format:"- %b %s __by__ (%an - %cr)

 "
 )

# shellcheck disable=SC2001
echo "$LOG" \
| sed "s/Merge pull request//"\
| sed "s/from.*__by__//g"\
>> "$FILE"


##create draft release
NEW_VERSION=v$(date +%F_%H%M)
###git commit -m "$NEW_VERSION" "$FILE"
###git tag "$VERSION"
gh release create "$NEW_VERSION"\
  -F "$FILE"\
  --title "$NEW_VERSION"\
  --draft
