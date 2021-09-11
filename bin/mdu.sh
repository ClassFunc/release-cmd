# tham khao:
# https://github.com/github/hub/issues/2118,
# https://stackoverflow.com/questions/8136178/git-log-between-tags
# https://stackoverflow.com/questions/39253307/export-git-log-into-an-excel-file

 # shellcheck disable=SC2046
# clear
echo "--- Report Per Member Efforts"

PROJECT_NAME=$(basename $(git rev-parse --show-toplevel))

ON=$1
SINCE=$2
UNTIL=$3

create_report (){

  DIR=release_month_report
  FILE=$DIR/"$PROJECT_NAME-$SINCE-to-$UNTIL-on-$ON-$1.md"

  if [[ ! -e $FILE ]]; then
    mkdir -p $DIR
    touch "$FILE"
  fi

  echo "
($1) Pull Request merged from $SINCE to $UNTIL on \`$ON\`

---

  | PR      | Title   | By  | Date     |
  | :---    | :---   | :--- | :--- |" > "$FILE"

  LOG=$(git log --merges\
    "$ON"\
   --since="$SINCE"\
   --until="$UNTIL"\
   --grep='Merge pull request'\
   --author="$1" \
   --pretty=format:"%s __end_subject__  | %b | %an | %cs |"
   )

  # shellcheck disable=SC2001
  echo "$LOG" \
  | sed "s/Merge pull request/\|/"\
  | sed "s/from.*__end_subject__//g"\
  >> "$FILE"

  echo "created file: $FILE"
}

generate_for_all_user(){
  USERS=$(
  git log --merges --grep "Merge pull request" --format="%an" \
  |sort | uniq
  )
  while read -r user
  do
#    echo "($user) from $SINCE to $UNTIL on \`$ON\`"
    create_report "$user"
  done <<< "$USERS"
}

generate_for_all_user
