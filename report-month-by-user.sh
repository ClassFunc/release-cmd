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

OF_TAG=$(git branch --show-current)
echo "to tag or branch ($OF_TAG): \c" #default current branch
read -r to_tag
[ -n "$to_tag" ] && OF_TAG=$to_tag

create_report (){

  DIR=release_month_report
  FILE=$DIR/"$SINCE-to-$UNTIL--$1.md"

  if [[ ! -e $FILE ]]; then
    mkdir -p $DIR
    touch "$FILE"
  fi

  echo -e "Cảm ơn tất cả vì sự nỗ lực của mọi người,

  Chúng ta đã có những update rất tuyệt vời từ $SINCE trong $OF_TAG

  ---" > "$FILE"

  echo -e "
  | PR      | Title   | By | Date     |
  | :---    | :---   | :--- | :--- |" >> "$FILE"

  LOG=$(git log --merges\
    "$OF_TAG"\
   --since="$SINCE"\
   --until="$UNTIL"\
   --grep='Merge pull request'\
   --author="$1" \
   --pretty=format:"%s __end_subject__   | %b | %an | %cs |"
   )

  # shellcheck disable=SC2001
  _RESULT=$( echo "$LOG" \
  | sed "s/Merge pull request/\|/"\
  | sed "s/from.*__end_subject__//g"
  )

  echo "$_RESULT" >> "$FILE"
}

generate_for_all_user(){
  EMAILS=$(
  git log --grep "Merge pull request" --format="%ae" \
  |sort | uniq
  )
  while read -r email
  do
    create_report "$email"
  done <<< "$EMAILS"
}

generate_for_all_user

