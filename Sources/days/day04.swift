class Day04: AdventDay {

    func getGrid() -> [[Tile]] {
        return Self.dataLines.map { line in
            return line.map({ $0 == "." ? .empty : .paper })
        }
    }

    func part1() -> Any {
        let grid = getGrid()
        var accessableRolls = 0
        for row in 0..<grid.count {
            for col in 0..<grid[0].count {
                if grid[row][col] == .empty {
                    continue
                }
                var adjacentRolls = 0
                for i in [-1, 0, 1] {
                    for j in [-1, 0, 1] {
                        if i == 0 && j == 0 {
                            continue
                        }
                        let (y, x) = (row + i, col + j)
                        if y < 0 || y > grid.count - 1 || x < 0 || x > grid[0].count - 1 {
                            continue
                        }
                        if grid[y][x] == .paper || grid[y][x] == .accessible {
                            adjacentRolls += 1
                        }
                    }
                }
                if adjacentRolls < 4 {
                    accessableRolls += 1
                }

            }
        }
        return accessableRolls
    }

    func part2() -> Any {
        var grid = getGrid()
        var totalRemovedRolls = 0
        while true {
            var localRemovedRolls = 0
            for row in 0..<grid.count {
                for col in 0..<grid[0].count {
                    if grid[row][col] == .empty {
                        continue
                    }
                    var adjacentRolls = 0
                    for i in [-1, 0, 1] {
                        for j in [-1, 0, 1] {
                            if i == 0 && j == 0 {
                                continue
                            }
                            let (y, x) = (row + i, col + j)
                            if y < 0 || y > grid.count - 1 || x < 0 || x > grid[0].count - 1 {
                                continue
                            }
                            if grid[y][x] == .paper || grid[y][x] == .accessible {
                                adjacentRolls += 1
                            }
                        }
                    }
                    if adjacentRolls < 4 {
                        grid[row][col] = .empty
                        localRemovedRolls += 1
                    }

                }
            }
            if localRemovedRolls == 0 {
                break
            }
            totalRemovedRolls += localRemovedRolls
        }
        return totalRemovedRolls
    }
}

enum Tile: CustomStringConvertible {
    case empty, paper, accessible

    var description: String {
        switch self {
        case .empty:
            return "."
        case .paper:
            return "@"
        case .accessible:
            return "X"
        }
    }
}
