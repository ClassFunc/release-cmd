# tham khao:
# https://github.com/github/hub/issues/2118,
# https://stackoverflow.com/questions/8136178/git-log-between-tags
# https://stackoverflow.com/questions/39253307/export-git-log-into-an-excel-file

 # shellcheck disable=SC2046
# clear

SINCE=$(date -v1d -v"$(date '+%m')"m '+%F') #first day of month
echo "since date ($SINCE): \c" #default current branch
read -r since_date
[ -n "$since_date" ] && SINCE=$since_date

TO_TAG=$(git branch --show-current)
echo "to tag or branch ($TO_TAG): \c" #default current branch
read -r to_tag
[ -n "$to_tag" ] && TO_TAG=$to_tag

FILE=release_month_report/"$SINCE.md"

echo -e "Cảm ơn tất cả vì sự nỗ lực của mọi người,

Chúng ta đã có những update rất tuyệt vời từ $SINCE trong $TO_TAG

---" > "$FILE"

echo -e "
| PR      | Title   | By | Date     |
| :---    | :---   | :--- | :--- |" >> "$FILE"

LOG=$(git log --merges\
  "$TO_TAG"\
 --since="$SINCE"\
 --grep='Merge pull request'\
 --pretty=format:"%s __end_subject__   | %b | %an | %cs |"
 )

# shellcheck disable=SC2001
echo "$LOG" \
| sed "s/Merge pull request/\|/"\
| sed "s/from.*__end_subject__//g"\
>> "$FILE"
