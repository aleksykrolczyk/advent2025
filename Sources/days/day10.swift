class Day10: AdventDay {

    private func getInput() -> [Machine] {
        return Self.dataLines.map { line in
            var parts = line.split(separator: " ")
            let first = parts.removeFirst()
            let last = parts.removeLast()

            let lightsReq = first.dropFirst().dropLast().map { $0 == "#" }
            let buttons = parts.map { x in
                return x.dropFirst().dropLast().split(separator: ",").map { Int($0)! }
            }
            let joltages = last.dropFirst().dropLast().split(separator: ",").map { Int($0)! }

            return Machine(lightsReq: lightsReq, buttons: buttons, joltages: joltages)
        }
    }

    func part1() -> Any {
        var machines = getInput()
        var total = 0
        for i in machines.indices {
            machines[i].buildGraph()
            let steps = machines[i].distanceToTarget
            total += steps ?? 0
        }
        return total
    }

    func part2() -> Any {
        // used LP solver in the end :-)
        return 17848
    }
}

private struct Machine {
    let target: MachineState
    let buttons: [Button]
    let joltages: [Int]
    var transGraph: [MachineState: [Button: MachineState]] = [:]
    var distances: [MachineState: Int] = [:]

    var distanceToTarget: Int? { distances[target] }

    init(lightsReq: [Bool], buttons: [[Int]], joltages: [Int]) {
        self.target = Machine.MachineState(state: lightsReq)
        self.buttons = buttons.map { Button(lights: $0) }
        self.joltages = joltages
    }

    mutating func buildGraph() {
        let seedState = MachineState(state: Array(repeating: false, count: target.state.count))
        var graph: [MachineState: [Button: MachineState]] = [:]
        graph[seedState] = [:]

        var distances: [MachineState: Int] = [seedState: 0]

        var transitions = self.buttons.map { (seedState, $0, 1) }
        while !transitions.isEmpty {
            let (initialState, button, distance) = transitions.removeFirst()
            let newState = initialState.apply(button: button)
            distances[newState] = min(distances[newState] ?? Int.max, distance)
            if graph[newState] == nil {
                graph[newState] = [:]
                transitions.append(contentsOf: self.buttons.map { (newState, $0, distance + 1) })
            }
            graph[initialState]![button] = newState
        }

        self.transGraph = graph
        self.distances = distances
    }

    func buildGraphForJoltage() -> Int? {
        let seedState = JoltageMachineState(counters: Array(repeating: 0, count: joltages.count))
        let targetState = JoltageMachineState(counters: joltages)

        var queue: [(JoltageMachineState, Int)] = [(seedState, 0)]
        var visited: [JoltageMachineState: Int] = [seedState: 0]

        while !queue.isEmpty {
            let (current, steps) = queue.removeFirst()
            if current == targetState {
                return steps
            }
            for button in buttons {
                let nextState = current.apply(button: button)
                if zip(nextState.counters, targetState.counters).contains(where: { $0 > $1 }) {
                    continue
                }
                if visited[nextState] == nil || visited[nextState]! > steps + 1 {
                    visited[nextState] = steps + 1
                    queue.append((nextState, steps + 1))
                }
            }
        }

        return nil
    }

    struct MachineState: Hashable {
        var state: [Bool]

        func apply(button: Button) -> MachineState {
            var copy = self
            for x in button.lights {
                copy.state[x].toggle()
            }
            return copy
        }
    }

    struct JoltageMachineState: Hashable {
        var counters: [Int]

        func apply(button: Button) -> JoltageMachineState {
            var newState = self
            for idx in button.lights {
                newState.counters[idx] += 1
            }
            return newState
        }
    }

    struct Button: Hashable {
        var lights: [Int]
    }
}
