class Day02: AdventDay {

    func getIds() -> [(String, String)] {
        let ids = Self.dataLines[0]
            .split { $0 == "-" || $0 == "," }
        var pairs: [(String, String)] = []
        for i in 0..<ids.count / 2 {
            pairs.append((String(ids[2 * i]), String(ids[2 * i + 1])))
        }
        return pairs
    }

    func part1() -> Any {
        let pairs = getIds()

        var total = 0
        for pair in pairs {
            for id in Int(pair.0)!...Int(pair.1)! {
                let idStr = String(id)
                if idStr.count % 2 != 0 {
                    continue
                }
                let parts = splitEvenly(str: idStr, numParts: 2)
                if parts[0] == parts[1] {
                    total += id
                }
            }

        }
        return total
    }

    func part2() -> Any {
        let pairs = getIds()

        var total = 0
        for pair in pairs {
            for id in Int(pair.0)!...Int(pair.1)! {
                let idStr = String(id)
                if idStr.count == 1 {
                    continue
                }
                for j in 2...idStr.count {
                    if idStr.count % j != 0 {
                        continue
                    }
                    let parts = splitEvenly(str: idStr, numParts: j)
                    if parts.allSatisfy({ $0 == parts[0] }) {
                        total += id
                        break
                    }
                }
            }
        }
        return total
    }
}

func splitEvenly(str: String, numParts: Int) -> [String] {
    let step = str.count / numParts
    var position = str.startIndex
    var parts: [String] = []
    for _ in 0..<numParts {
        let newPosition = str.index(position, offsetBy: step)
        let part = String(str[position..<newPosition])
        parts.append(part)
        position = newPosition
    }
    return parts
}
