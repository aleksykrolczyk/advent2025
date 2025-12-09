private struct Segment {
    let c1: Point
    let c2: Point

    var minX: Int { min(c1.x, c2.x) }
    var maxX: Int { max(c1.x, c2.x) }
    var minY: Int { min(c1.y, c2.y) }
    var maxY: Int { max(c1.y, c2.y) }
}

class Day09: AdventDay {
    func getInput() -> [Point] {
        return Self.dataLines.map { line in
            let parts = line.split(separator: ",")
            return Point(x: Int(parts[0])!, y: Int(parts[1])!)
        }
    }

    func part1() -> Any {
        let corners = getInput()
        var biggest = Int.min
        for i in 0..<corners.count - 1 {
            for j in i + 1..<corners.count {
                biggest = max(biggest, area(p1: corners[i], p2: corners[j]))
            }
        }
        return biggest
    }

    func part2() -> Any {
        let corners = getInput()
        let segments = computeGreenSegments(corners: corners)
        var biggest = Int.min
        for i in 0..<corners.count - 1 {
            jloop: for j in i + 1..<corners.count {
                let area = area(p1: corners[i], p2: corners[j])
                if biggest > area {
                    continue
                }
                for segment in segments {
                    if intersects(c1: corners[i], c2: corners[j], segment: segment) {
                        continue jloop
                    }
                }
                biggest = area
            }
        }
        return biggest
    }
}

private func area(p1: Point, p2: Point) -> Int {
    let dx = abs(p1.x - p2.x) + 1
    let dy = abs(p1.y - p2.y) + 1
    return dx * dy
}

private func computeGreenSegments(corners: [Point]) -> [Segment] {
    var segments: [Segment] = Array()
    segments.reserveCapacity(corners.count - 1)
    for i in 0..<corners.count - 1 {
        segments.append(Segment(c1: corners[i], c2: corners[i + 1]))
    }
    segments.append(Segment(c1: corners.last!, c2: corners.first!))
    return segments
}

private func intersects(c1: Point, c2: Point, segment: Segment) -> Bool {
    let rectMinX = min(c1.x, c2.x)
    let rectMaxX = max(c1.x, c2.x)
    let rectMinY = min(c1.y, c2.y)
    let rectMaxY = max(c1.y, c2.y)

    if (segment.maxX <= rectMinX || segment.minX >= rectMaxX)
        || (segment.maxY <= rectMinY || segment.minY >= rectMaxY)
    {
        return false
    }
    return true

}
