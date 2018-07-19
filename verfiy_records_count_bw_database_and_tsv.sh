#!/bin/bash
# open db properties file
file="/home/2018/summer/nyu/6513/vc1436/P1/db.properties"
. $file

# define directory containing TSV files
tsv_directory="/home/2018/summer/nyu/6513/vc1436/P1/test_run/input/"

# go into directory
cd $tsv_directory

# get a list of TSV files in directory
tsv_files=`ls -1 *.tsv`
files_count=`ls $tsv_directory|wc -l`

echo "Directory = '$tsv_directory'"
echo "Number of files = $files_count"

total=0

# loop through tsv files
for tsv_file in ${tsv_files[@]}
do
  # get file name
  filename=`echo $tsv_file | sed 's/\(.*\)\..*/\1/'`

  # get table name
  table_prefix="amzn_reviews_"
  table_name=$table_prefix$filename
  
  # get records count from file
  count_file=`cat $tsv_file|wc -l`
  count_file=`echo $((count_file-1))` #decrement count by 1 for header
  total=`echo $((total + count_file))`
 
  # get records count from table
  count_sql=$(mysql -u $user -p$password $db -e "select count(*) as c from \`$table_name\`;")
  count_sql=`echo $count_sql |sed 's/c //g'`
  
  # validate records count
  if [ $count_sql==$count_file ]; then result="equal"; else result="unequal"; fi
  echo "For $tsv_file, records are $result , File count = $count_file Table count = $count_sql"
done
  echo "Total records : $total"
exit

