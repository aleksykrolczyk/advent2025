#! /bin/bash

dayNum=$1

mainFile="./Sources/main.swift"

dataFile="./Sources/data/day${dayNum}.txt"
codeFile="./Sources/days/day${dayNum}.swift"
code="class Day${dayNum}: AdventDay {

    func part1() -> Any {
        return \"\"
    }

    func part2() -> Any {
        return \"\"
    }
}"

if [ -f "$dataFile" ]; then
    echo "data file $dataFile already exists"
else
    touch "$dataFile"
    echo "data file $dataFile created"
fi

if [ -f "$codeFile" ]; then
    echo "code file $codeFile already exists"
else
    touch "$codeFile"
    echo "$code" > "$codeFile"
    echo "code file $codeFile created"
fi

if [ -f "$mainFile" ]; then
    sed -i "" "s/let day: AdventDay = Day[0-9][0-9]()/let day: AdventDay = Day${dayNum}()/g" "$mainFile"
    echo "updated main.swift to use Day${dayNum}"
fi