class Day07: AdventDay {

    static var memo: [Point: Int] = [:]

    private func getInput() -> [[Tile]] {
        return Self.dataLines.map { line in
            return line.map {
                switch $0 {
                case ".": .empty
                case "^": .splitter
                case "S": .emitter
                default: fatalError()
                }
            }
        }
    }

    func part1() -> Any {
        let matrix = getInput()
        var beams: Set<Int> = Set()
        var hitCount = 0
        beams.insert(matrix[0].firstIndex(of: .emitter)!)
        for row in matrix[1...] {
            var newBeams: Set<Int> = Set()
            for beam in beams {
                if row[beam] == .splitter {
                    hitCount += 1
                    if beam - 1 >= 0 {
                        newBeams.insert(beam - 1)
                    }
                    if beam + 1 <= row.count - 1 {
                        newBeams.insert(beam + 1)
                    }
                } else {
                    newBeams.insert(beam)
                }
            }
            beams = newBeams
        }
        return hitCount
    }

    fileprivate func trace(_ beam: Int, in matrix: [[Tile]], row: Int) -> Int {
        if row == matrix.count {
            return 1
        }
        if matrix[row][beam] == .splitter {
            if let res = Self.memo[Point(x: beam, y: row)] {
                return res
            }

            var res = 0
            if beam - 1 >= 0 {
                res += trace(beam - 1, in: matrix, row: row + 1)
            }
            if beam + 1 <= matrix[row].count - 1 {
                res += trace(beam + 1, in: matrix, row: row + 1)
            }

            Self.memo[Point(x: beam, y: row)] = res
            return res
        }
        return trace(beam, in: matrix, row: row + 1)
    }

    func part2() -> Any {
        let matrix = getInput()
        let source = matrix[0].firstIndex(of: .emitter)!
        let timelines = trace(source, in: matrix, row: 1)
        return timelines
    }
}

private enum Tile: CustomStringConvertible {
    case empty, splitter, beam, emitter

    var description: String {
        switch self {
        case .empty: "."
        case .splitter: "^"
        case .beam: "|"
        case .emitter: "S"
        }
    }
}
