class Day11: AdventDay {

    private func getInput() -> [String: Set<String>] {
        var transitions: [String: Set<String>] = [:]
        Self.dataLines.forEach { line in
            let parts = line.split(separator: ":")
            let a = String(parts[0])
            let b = parts[1].split(separator: " ").map { String($0) }
            transitions[a] = Set(b)
        }
        return transitions
    }
    func part1() -> Any {
        Self.memo = [:]
        let transitions = getInput()
        let paths = findPaths1(
            from: "you",
            to: "out",
            transitions: transitions,
        )
        return paths
    }

    func part2() -> Any {
        Self.memo = [:]
        let transitions = getInput()
        let paths = findPaths2(
            from: "svr",
            to: "out",
            transitions: transitions,
            dacVisited: false,
            fftVisited: false,
        )
        return paths
    }

    private struct State: Hashable {
        var current: String
        var dacVisited: Bool
        var fftVisited: Bool
    }

    private static var memo: [State: Int] = [:]

    private func findPaths1(
        from current: String, to target: String, transitions: [String: Set<String>]
    ) -> Int {
        guard let currentTransitions = transitions[current] else {
            return 0
        }

        if currentTransitions.contains(target) {
            return 1
        }

        var total = 0
        for next in currentTransitions {
            total += findPaths1(
                from: next,
                to: target,
                transitions: transitions,
            )
        }
        return total
    }

    private func findPaths2(
        from current: String,
        to target: String,
        transitions: [String: Set<String>],
        dacVisited: Bool,
        fftVisited: Bool,
    ) -> Int {
        let currentState = State(current: current, dacVisited: dacVisited, fftVisited: fftVisited)
        if let x = Self.memo[currentState] {
            return x
        }

        guard let currentTransitions = transitions[current] else {
            return 0
        }

        if currentTransitions.contains(target) {
            return dacVisited && fftVisited ? 1 : 0
        }

        var total = 0
        for next in currentTransitions {
            total += findPaths2(
                from: next,
                to: target,
                transitions: transitions,
                dacVisited: dacVisited || (next == "dac"),
                fftVisited: fftVisited || (next == "fft"),
            )
        }

        Self.memo[currentState] = total
        return total
    }
}
