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
            echo "Invalid $num at ($(($startingCell / 9 + 1)),$(($cell + 1))), while validating row"
            return 1
        fi

        #echo "${foundNumbers[@]}"
    done
}

ValidateCol () {
    sudoku=$1
    startingCell=$2

    foundNumbers=(0 0 0 0 0 0 0 0 0)
    for cell in {0..8}
    do
        num=${sudoku[$(($startingCell + $cell * 9))]}
        if [ ${foundNumbers[$(($num - 1))]} -eq 0 ]; then
            foundNumbers[$(($num - 1))]=$num
        else
            echo "Invalid $num at ($(($cell + 1)),$(($startingCell + 1))), while validating col"
            return 1
        fi

        #echo "${foundNumbers[@]}"
    done
}

ValidateSquare () {
    sudoku=$1
    startingCell=$2

    foundNumbers=(0 0 0 0 0 0 0 0 0)
    for cell in 0 1 2 9 10 11 18 19 20;
    do
        num=${sudoku[$(($startingCell + $cell))]}
        if [ ${foundNumbers[$(($num - 1))]} -eq 0 ]; then
            foundNumbers[$(($num - 1))]=$num
        else
            echo "Invalid $num at ($(($startingCell / 9 + 1)),$(($cell / 9 + 1))), while validating square"
            return 1
        fi

        #echo "${foundNumbers[@]}"
    done
}

# Start of Main
sudoku=(1 2 3 4 5 6 7 8 9 2 3 4 5 6 7 8 9 1 3 4 5 6 7 8 9 1 2 4 5 6 7 8 9 1 2 3 5 6 7 8 9 1 2 3 4 6 7 8 9 1 2 3 4 5 7 8 9 1 2 3 4 5 6 8 9 1 2 3 4 5 6 7 9 1 2 3 4 5 6 7 8)

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

for col in {0..8}
do
    ValidateCol $sudoku $(($col))
done

for sq in 0 3 6 27 30 33 54 57 60;
do
    ValidateSquare $sudoku $(($sq))
done

