#!/usr/bin/env bash

cd $PATH_TO_YOUR_FOLDER

# Retrieve the data and create the array
COUNTER=0
for i in $(git ls-files $PATH_TO_YOUR_SRC); do
    key=$(echo "$i" | sed -e 's/\//_/g')
    array[COUNTER]="$(git whatchanged -n 10000 --format=oneline $i | wc -l):${key/.php/__}"
    COUNTER=$((COUNTER+1))
done

# Order the array
orderedArr=()
orderedArr+=($(for k in "${!array[@]}"; do echo ${array["$k"]}; done | sort -rn -k1))

FILE=$PATH_TO_REPORT_FOLDER

# Put data in file
echo "[" > $FILE
echo "['File', 'Rate change']," >> $FILE
for i in "${!orderedArr[@]}"
do
    string="${orderedArr["$i"]}"
    set -f
    mapped_array=(${string//:/ })
    echo "[ \"${mapped_array["1"]}\" , ${mapped_array["0"]} ]," >> $FILE
done
echo "]" >> $FILE
