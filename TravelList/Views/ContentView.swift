import SwiftUI

struct ContentView: View {
    @State private var lines: [String] = []

    var body: some View {
        NavigationStack {
            List(Array(lines.enumerated()), id: \.offset) { _, line in
                Text(line)
                    .font(line.hasPrefix(" ") ? Font.body : Font.headline)
            }
            .navigationTitle("TravelList")
            .toolbar {
                Button("Запустити") {
                    runScenario()
                }
            }
            .onAppear {
                runScenario()
            }
        }
    }

    private func runScenario() {
        var scenario = TripScenario()
        lines = scenario.run()
    }
}

#Preview {
    ContentView()
}
