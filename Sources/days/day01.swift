class Day01: AdventDay {

    func getRotations() -> [Rotation] {
        return Self.dataLines.map { line in
            let direction = String(line.prefix(1))
            let amount = Int(line.dropFirst())!
            return Rotation(direction: direction == "R" ? .right : .left, amount: amount)
        }

    }

    func part1() -> Any {
        let moves = self.getRotations()

        var zerosCount = 0
        var position = 50
        for move in moves {
            switch move.direction {
            case .left:
                position = (position - move.amount) % 100
            case .right:
                position = (position + move.amount) % 100
            }
            if position == 0 {
                zerosCount += 1
            }
        }

        return zerosCount
    }
    func part2() -> Any {
        let moves = self.getRotations()

        var zerosCount = 0
        var position = 50
        for move in moves {
            for _ in 0..<move.amount {
                position = move.direction == .left ? position - 1 : position + 1
                if position == 100 {
                    position = 0
                }
                if position == -1 {
                    position = 9
                }
                if position == 0 {
                    zerosCount += 1
                }
            }
            print(position)

        }
        return zerosCount
    }
}

enum Direction {
    case left, right
}

struct Rotation: CustomStringConvertible {
    var description: String {
        return "\(direction == .left ? "<" : ">") \(amount)"
    }

    let direction: Direction
    let amount: Int
}
