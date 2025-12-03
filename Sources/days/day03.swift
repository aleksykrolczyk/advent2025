class Day03: AdventDay {

    func getBatteries() -> [[Int]] {
        return Self.dataLines.map { line in
            return line.map { $0.hexDigitValue! }
        }
    }

    func toPositionsDict(bank: [Int]) -> [Int: [Int]] {
        var positions = emptyPositionsDict()
        for i in 0..<bank.count {
            positions[bank[i]]?.append(i)
        }
        return positions
    }

    func geLargestJoltage(
        positions: [Int: [Int]],
        bankLength: Int,
        n: Int,
        currentPosition: Int = -1,
    )
        -> Int
    {
        if n == 0 {
            return 0
        }

        for nthDigit in stride(from: 9, to: 0, by: -1) {
            for nthPosition in positions[nthDigit]! {
                if nthPosition >= bankLength - n + 1 || nthPosition <= currentPosition {
                    continue
                }
                return nthDigit * 10 ** (n - 1)
                    + geLargestJoltage(
                        positions: positions,
                        bankLength: bankLength,
                        n: n - 1,
                        currentPosition: nthPosition
                    )
            }
        }

        return -1
    }

    func part1() -> Any {
        let batteries = getBatteries()
        var total = 0
        for bank in batteries {
            let positions = toPositionsDict(bank: bank)
            let joltage = geLargestJoltage(positions: positions, bankLength: bank.count, n: 2)
            total += joltage

        }
        return total
    }

    func part2() -> Any {
        let batteries = getBatteries()
        var total = 0
        for bank in batteries {
            let positions = toPositionsDict(bank: bank)
            let joltage = geLargestJoltage(positions: positions, bankLength: bank.count, n: 12)
            total += joltage

        }
        return total
    }
}

func emptyPositionsDict() -> [Int: [Int]] {
    var positions: [Int: [Int]] = [:]
    for i in 0...9 {
        positions[i] = []
    }
    return positions
}
