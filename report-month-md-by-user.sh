# tham khao:
# https://github.com/github/hub/issues/2118,
# https://stackoverflow.com/questions/8136178/git-log-between-tags
# https://stackoverflow.com/questions/39253307/export-git-log-into-an-excel-file

 # shellcheck disable=SC2046
# clear
SINCE=$(date -v1d -v"$(date '+%m')"m '+%F') #first day of month
echo "since date ($SINCE): \c"
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

create_report (){

  DIR=release_month_report
  FILE=$DIR/"$SINCE-to-$UNTIL--$1.md"

  if [[ ! -e $FILE ]]; then
    mkdir -p $DIR
    touch "$FILE"
  fi

  echo -e "

  ($1) from $SINCE to $UNTIL on \`$ON\`

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

}

generate_for_all_user(){
  USERS=$(
  git log --grep "Merge pull request" --format="%an" \
  |sort | uniq
  )
  while read -r user
  do
    echo "($user) from $SINCE to $UNTIL on \`$ON\`"
    create_report "$user"
  done <<< "$USERS"
}

generate_for_all_user

