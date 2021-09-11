# tham khao:
# https://github.com/github/hub/issues/2118,
# https://stackoverflow.com/questions/8136178/git-log-between-tags
# https://stackoverflow.com/questions/39253307/export-git-log-into-an-excel-file

 # shellcheck disable=SC2046
# clear
echo "Report All Member Efforts"

echo "git fetching..."
git fetch;
echo "fetch done."

PROJECT_NAME=$(basename $(git rev-parse --show-toplevel))

SINCE=$(date -v1d -v"$(date '+%m')"m '+%F') #first day of month
echo "since date ($SINCE): \c" #default current branch
read -r since_date
[ -n "$since_date" ] && SINCE=$since_date

UNTIL=$(date "+%F") #today
echo "until date ($UNTIL): \c"
read -r until_date
[ -n "$until_date" ] && UNTIL=$until_date

ON=$(git branch --show-current)
echo "on tag or branch ($ON): \c" #default current branch
read -r on
[ -n "$on" ] && ON=$on

FILE=release_month_report/"$PROJECT_NAME-$SINCE-to-$UNTIL-all.csv"
DIR=release_month_report

if [[ ! -e $FILE ]]; then
  mkdir -p $DIR
  touch "$FILE"
fi

echo "PR,Title,By,Date" > "$FILE"

git log --merges\
  "$ON"\
 --since="$SINCE"\
  --until="$UNTIL"\
 --grep='Merge pull request'\
 --pretty=format:"%s __end_subject ;;; %b ;;; %an ;;; %cs" \
| awk '{
gsub(/Merge pull request/,"")
print
}'\
| awk '{
gsub(/from.*__end_subject/,"")
print
}'\
| awk '{
gsub(",", "")
print
}' \
| awk '{
gsub(";;;", ",")
print
}' \
>> "$FILE"

echo "created file: $FILE"
