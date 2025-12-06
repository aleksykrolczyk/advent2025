class Day05: AdventDay {

    func getInput() -> ([ClosedRange<Int>], [Int]) {
        let s = Self.dataLines.split(whereSeparator: { $0.isEmpty })
        let ranges = s[0].map { line in
            let x = line.split(separator: "-")
            return ClosedRange(uncheckedBounds: (Int(x[0])!, Int(x[1])!))
        }
        let ids = s[1].map { Int($0)! }
        return (ranges, ids)
    }

    func part1() -> Any {
        let (ranges, ids) = getInput()
        var freshIds = 0
        for id in ids {
            for range in ranges {
                if range.contains(id) {
                    freshIds += 1
                    break
                }
            }
        }
        return freshIds
    }

    func part2() -> Any {
        let (ranges, _) = getInput()
        var freshRanges: [ClosedRange<Int>] = []
        for range in ranges {
            freshRanges.append(range)
            freshRanges = simplifyRanges(ranges: &freshRanges)
        }

        var total = 0
        for range in freshRanges {
            total += range.upperBound - range.lowerBound + 1
        }

        return total
    }
}

func simplifyRanges<T: Comparable>(ranges: inout [ClosedRange<T>]) -> [ClosedRange<T>] {
    if ranges.count == 1 {
        return ranges
    }
    for i in 0..<ranges.count - 1 {
        for j in (i + 1)..<ranges.count {
            if ranges[i].overlaps(ranges[j]) {
                let newRange = ClosedRange(
                    uncheckedBounds: (
                        min(ranges[i].lowerBound, ranges[j].lowerBound),
                        max(ranges[i].upperBound, ranges[j].upperBound),
                    )
                )
                // modyfing array while iteraing over it lets goo!!!
                // (if you change order for the next two lines you're gonna have a bad time!)
                ranges.remove(at: j)
                ranges.remove(at: i)

                ranges.append(newRange)
                return simplifyRanges(ranges: &ranges)
            }
        }
    }
    return ranges
}
