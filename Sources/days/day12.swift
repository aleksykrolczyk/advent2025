class Day12: AdventDay {

    private func getInput() -> ([Present], [Region]) {
        let stuff = Self.dataLines.split(whereSeparator: { $0.isEmpty })
        let presents = stuff.dropLast().map { thing in
            let m = thing.dropFirst().map { line in
                return line.map { $0 == "#" ? Tile.present : Tile.empty }
            }
            return Present(m: m)
        }
        let regions = stuff.last!.map { line in
            let parts = line.split(separator: " ")
            return Region(
                width: Int(parts[0].dropLast().split(separator: "x")[0])!,
                height: Int(parts[0].dropLast().split(separator: "x")[1])!,
                presents: parts.dropFirst().map { Int($0)! }
            )

        }
        return (presents, regions)
    }

    func part1() -> Any {
        // i don't kow if i'm happy or angry that this sufficed
        let (presents, regions) = getInput()
        var total = 0
        for region in regions {
            let area = region.width * region.height
            let requiredSpace = region.presents.enumerated()
                .map { (i, presentCount) in
                    return presents[i].count * presentCount
                }
                .reduce(0, +)
            if area >= requiredSpace {
                total += 1
            }
        }
        return total
    }

    func part2() -> Any {
        return ""
    }
}

private enum Tile: CustomStringConvertible {
    case present, empty
    var description: String {
        switch self {
        case .present: "#"
        case .empty: "."
        }
    }
}

private struct Present {
    let m: [[Tile]]
    let count: Int

    init(m: [[Tile]]) {
        self.m = m
        self.count = m.map { $0.count(where: { tile in tile == .present }) }.reduce(0, +)
    }
}

private struct Region {
    let width: Int
    let height: Int
    let presents: [Int]
}
