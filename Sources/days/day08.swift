class Day08: AdventDay {

    private func getInput() -> [JunctionBox] {
        return Self.dataLines.map { line in
            let nums = line.split(separator: ",").map { Int($0)! }
            return JunctionBox(x: nums[0], y: nums[1], z: nums[2])
        }
    }

    private func getConnections(boxes: [JunctionBox]) -> [(JunctionBox, JunctionBox, Int)] {
        var connections: [(JunctionBox, JunctionBox, Int)] = Array()
        connections.reserveCapacity(boxes.count * (boxes.count - 1) / 2)

        for i in 0..<boxes.count - 1 {
            for j in i + 1..<boxes.count {
                let a = boxes[i]
                let b = boxes[j]
                let d = a.distanceSquared(to: b)
                connections.append((a, b, d))
            }
        }
        connections.sort { $0.2 < $1.2 }
        return connections
    }

    func part1() -> Any {
        let boxes = getInput()
        let connections = getConnections(boxes: boxes)

        var boxToCircuit: [JunctionBox: Circuit] = [:]
        var allCircuits: [Circuit] = []

        for (b1, b2, _) in connections[..<1000] {
            let (c1, c2) = (boxToCircuit[b1], boxToCircuit[b2])
            if c1 == nil && c2 == nil {
                let newCircuit = Circuit([b1, b2])
                boxToCircuit[b1] = newCircuit
                boxToCircuit[b2] = newCircuit
                allCircuits.append(newCircuit)
            } else if let c1, c2 == nil {
                c1.boxes.insert(b2)
                boxToCircuit[b2] = c1
            } else if let c2, c1 == nil {
                c2.boxes.insert(b1)
                boxToCircuit[b1] = c2
            } else if let c1, let c2 {
                if c1 === c2 { continue }
                c1.boxes.formUnion(c2.boxes)
                for b in c2.boxes {
                    boxToCircuit[b] = c1
                }
                allCircuits.remove(at: allCircuits.firstIndex(where: { $0 === c2 })!)
            }
        }
        let top3 = allCircuits.map { $0.size }.sorted(by: >).prefix(3)
        return top3.reduce(1, *)
    }

    func part2() -> Any {
        let boxes = getInput()
        let connections = getConnections(boxes: boxes)

        var boxToCircuit: [JunctionBox: Circuit] = [:]
        var res = 0

        for (b1, b2, _) in connections {
            let (c1, c2) = (boxToCircuit[b1], boxToCircuit[b2])
            if c1 == nil && c2 == nil {
                let newCircuit = Circuit([b1, b2])
                boxToCircuit[b1] = newCircuit
                boxToCircuit[b2] = newCircuit
            } else if let c1, c2 == nil {
                c1.boxes.insert(b2)
                boxToCircuit[b2] = c1
            } else if let c2, c1 == nil {
                c2.boxes.insert(b1)
                boxToCircuit[b1] = c2
            } else if let c1, let c2 {
                if c1 === c2 { continue }
                c1.boxes.formUnion(c2.boxes)
                for b in c2.boxes {
                    boxToCircuit[b] = c1
                }
            }
            res = b1.x * b2.x
        }

        return res
    }
}

private class Circuit {
    var boxes: Set<JunctionBox>
    init(_ boxes: Set<JunctionBox>) {
        self.boxes = boxes
    }
    var size: Int { boxes.count }
}

private class JunctionBox: CustomStringConvertible, Hashable {
    let x: Int
    let y: Int
    let z: Int

    static func == (lhs: JunctionBox, rhs: JunctionBox) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }

    init(x: Int, y: Int, z: Int, circuit: Int? = nil) {
        self.x = x
        self.y = y
        self.z = z
    }

    var description: String {
        return "(\(x), \(y), \(z))"
    }

    func distanceSquared(to other: JunctionBox) -> Int {
        return (x - other.x) ** 2 + (y - other.y) ** 2 + (z - other.z) ** 2
    }

}
