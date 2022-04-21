#!/bin/bash
# PROJECT: Wavefront Alignments Algorithms (Unitary Tests)
# LICENCE: MIT License 
# AUTHOR(S): Santiago Marco-Sola <santiagomsola@gmail.com>
# DESCRIPTION: Compares alignments (*.alg) from two folders
# USAGE: ./wfa.utest.cmp.alignments.sh wfa_results_folder_1 wfa_results_folder_2

# Parameters
FOLDER1=$1
FOLDER2=$2

echo "> Comparing $FOLDER1 vs $FOLDER2"
for FILE_ALG1 in $FOLDER1/*.alg
do
  FILENAME=$(basename -- "$FILE_ALG1")
  PREFIX=${FILENAME%.*}
  FILE_ALG2="$FOLDER2/$FILENAME"
  echo -ne "[UTest::$PREFIX]  \t"
  # Check existence
  if [[ ! -f "$FILE_ALG2" ]]
  then
    echo "$FILE_ALG2 doesn't exist."
    continue
  fi
  # Check diff
  if [[ $(diff $FILE_ALG1 $FILE_ALG2) ]] 
  then
    if [[ $(diff  <(awk '{print $1}' $FILE_ALG1) <(awk '{print $1}' $FILE_ALG2)) ]]
    then
      echo "Error"
      continue
    else
      echo -n "OK-Score"
    fi
  else
    echo -n "OK"
  fi
  # Stats
  T1=$(grep -m1 "Time.Alignment" $FOLDER1/$PREFIX.log | awk '{print $3" "$4}')
  T2=$(grep -m1 "Time.Alignment" $FOLDER2/$PREFIX.log | awk '{print $3" "$4}')  
  M1=$(grep -m1 "Maximum resident set size" $FOLDER1/$PREFIX.log | tr -d "(:)" | awk '{print $6" "$5}')
  M2=$(grep -m1 "Maximum resident set size" $FOLDER2/$PREFIX.log | tr -d "(:)" | awk '{print $6" "$5}')
  echo -e "\tTIME($T1,$T2)\tMEM($M1,$M2)"
done
