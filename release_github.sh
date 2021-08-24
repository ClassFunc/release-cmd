# tham khao:
# https://github.com/github/hub/issues/2118,
# https://stackoverflow.com/questions/8136178/git-log-between-tags

 # shellcheck disable=SC2046
# clear
FROM=$(git describe --tags --abbrev=0)
echo "from commit hash or tag or branch ($FROM): \c"
read -r from
[ -n "$from" ] && FROM=$from
#echo "$FROM"

TO=$(git branch --show-current)
echo "to commit hash or tag or branch ($TO): \c"
read -r to
[ -n "$to" ] && TO=$to

FILE=release_github.md
#echo "$COMPARE"
echo -e "
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
#NEW_VERSION=v$(date +%F_%H%M)
#gh release create "$NEW_VERSION"\
#  -F "$FILE"\
#  --title "$NEW_VERSION"\
#  --draft
