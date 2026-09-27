import SwiftUI

struct CountryListView: View {
    @StateObject private var viewModel: CountryListViewModel
    @State private var isScenarioPresented = false

    init(viewModel: @autoclosure @escaping () -> CountryListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Країни")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        regionMenu
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Демо") {
                            isScenarioPresented = true
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Text("У списку подорожей: \(viewModel.tripCount)")
                        .font(.footnote)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(.bar)
                }
                .sheet(isPresented: $isScenarioPresented) {
                    ScenarioLogView()
                }
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let message = viewModel.errorMessage {
            Text(message)
                .foregroundStyle(.secondary)
        } else {
            List(viewModel.countries) { country in
                CountryRowView(
                    country: country,
                    isInTrips: viewModel.isInTrips(country),
                    onToggle: { viewModel.toggleTrip(country) }
                )
            }
        }
    }

    private var regionMenu: some View {
        Menu {
            Picker("Регіон", selection: $viewModel.selectedRegion) {
                Text("Усі регіони").tag(Region?.none)
                ForEach(Region.allCases, id: \.self) { region in
                    Text(region.title).tag(Region?.some(region))
                }
            }
        } label: {
            Label(viewModel.selectedRegion?.title ?? "Усі", systemImage: "line.3.horizontal.decrease.circle")
        }
    }
}
