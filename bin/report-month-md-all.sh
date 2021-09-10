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
ON=$1
SINCE=$2
UNTIL=$3

DIR=release_month_report
FILE=$DIR/"$PROJECT_NAME-$SINCE-to-$UNTIL-on-$ON-all.md"

if [[ ! -e $FILE ]]; then
  mkdir -p $DIR
  touch "$FILE"
fi

echo -e "
Pull Request merged from $SINCE to $UNTIL on \`$ON\`

---

| PR      | Title   | By | Date     |
| :---    | :---   | :--- | :--- |" > "$FILE"

LOG=$(git log --merges\
  "$ON"\
 --since="$SINCE"\
 --until="$UNTIL"\
 --grep='Merge pull request'\
 --pretty=format:"%s __end_subject__   | %b | %an | %cs |"
 )

# shellcheck disable=SC2001
echo "$LOG" \
| sed "s/Merge pull request/\|/"\
| sed "s/from.*__end_subject__//g"\
>> "$FILE"

echo "created file: $FILE"
