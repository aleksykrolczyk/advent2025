class Day06: AdventDay {

    func part1() -> Any {
        let (numbers, ops) = getInput1()
        var total = 0
        for i in 0..<ops.count {
            var colTotal = numbers[0][i]
            for j in 1..<numbers.count {
                colTotal = ops[i](colTotal, numbers[j][i])
            }
            total += colTotal
        }
        return total
    }

    func part2() -> Any {
        let (numbers, ops) = getInput2()
        var total = 0
        for i in 0..<ops.count {
            total += numbers[i].reduce(ops[i].defaultValue, ops[i].apply)
        }
        return total
    }

    func getInput1() -> ([[Int]], [(Int, Int) -> Int]) {
        var ops: [(Int, Int) -> Int] = []
        let opsStr = Self.dataLines.last!.split(separator: " ")
        for opStr in opsStr {
            switch opStr {
            case "*":
                ops.append(*)
            case "+":
                ops.append(+)
            default:
                fatalError()
            }
        }
        let numbers = Self.dataLines.dropLast().map { line in
            return line.split(separator: " ").map { Int($0)! }
        }
        return (numbers, ops)
    }

    func getInput2() -> ([[Int]], [Operator]) {
        var opsIndices = Self.dataLines.last!.enumerated().compactMap { $1 == " " ? nil : $0 }
        opsIndices.append(Self.dataLines.last!.count + 1)
        var colNumbers: [[Int]] = Array(repeating: [], count: opsIndices.count - 1)
        for i in 1..<opsIndices.count {
            let length = opsIndices[i] - opsIndices[i - 1]
            for col in 1..<length {
                var currentNumber = 0
                var power = 0
                for row in stride(from: Self.dataLines.count - 1, through: 0, by: -1) {
                    let digit = Self.dataLines[row][opsIndices[i] - col - 1]
                    if digit.isHexDigit {
                        currentNumber += digit.hexDigitValue! * (10 ** power)
                        power += 1
                    }
                }
                colNumbers[i - 1].append(currentNumber)
            }
        }

        let ops: [Operator] = Self.dataLines.last!.split(separator: " ").map {
            switch $0 {
            case "*":
                return .mul
            case "+":
                return .add
            default:
                fatalError()
            }
        }
        return (colNumbers, ops)
    }
}

func getLongestNumberInColumn(numbers: [[Int]], column: Int) -> Int {
    var (longestIndex, length) = (-1, -1)
    for j in 0..<numbers.count {
        if numbers[j][column].length > length {
            (longestIndex, length) = (j, numbers[j][column].length)
        }
    }
    return numbers[longestIndex][column]
}

enum Operator {
    case add, mul

    func apply<T: Numeric>(_ a: T, _ b: T) -> T {
        return switch self {
        case .add: a + b
        case .mul: a * b
        }
    }

    var defaultValue: Int {
        return switch self {
        case .add: 0
        case .mul: 1
        }
    }
}
