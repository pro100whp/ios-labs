import SwiftUI

struct ScenarioLogView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var lines: [String] = []

    var body: some View {
        NavigationStack {
            List(Array(lines.enumerated()), id: \.offset) { _, line in
                Text(line)
                    .font(line.hasPrefix(" ") ? Font.body : Font.headline)
            }
            .navigationTitle("Сценарій ПР1")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрити") {
                        router.dismissSheet()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Запустити") {
                        runScenario()
                    }
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
