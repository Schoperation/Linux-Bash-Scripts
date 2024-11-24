#!/bin/bash

ValidateRow () {
    sudoku=$1
    startingCell=$2
    
    foundNumbers=(0 0 0 0 0 0 0 0 0)
    for cell in {0..8}
    do
        num=${sudoku[$(($startingCell + $cell))]}
        if [ ${foundNumbers[$(($num - 1))]} -eq 0 ]; then
            foundNumbers[$(($num - 1))]=$num
        else
            echo "Invalid $num at ($(($startingCell / 9 + 1)),$(($cell + 1)))"
            return 1
        fi

        #echo "${foundNumbers[@]}"
    done
}

# Start of Main
sudoku=()

echo "Enter in your Sudoku grid one row at a time."
echo "E.g. 123456789"
echo

i=0
while [ $i -lt 9 ]
do
    read -p "Enter in line number $(($i + 1)): " line
    if ! [[ $line =~ ^[1-9]{9}$ ]]; then
        echo "Needs to be 9 digits long, 1 thru 9"
        continue
    fi

    for j in {8..0}
    do
        sudoku+=($(($line / 10**$j)))
        line=$(($line - $line / 10**$j * 10**$j))
    done

    ((i++))
done

for row in {0..72..9}
do
    ValidateRow $sudoku $(($row))
done

