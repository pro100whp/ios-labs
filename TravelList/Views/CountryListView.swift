import SwiftUI

struct CountryListView: View {
    @ObservedObject var viewModel: CountryListViewModel
    @EnvironmentObject private var router: AppRouter

    init(viewModel: CountryListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .navigationTitle("Країни")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    regionMenu
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        router.present(.scenario)
                    } label: {
                        Image(systemName: "play.circle")
                    }
                    .accessibilityLabel("Сценарій ПР1")
                    Button {
                        router.push(.trips)
                    } label: {
                        Image(systemName: "suitcase")
                    }
                    .accessibilityLabel("Мої подорожі")
                }
            }
            .safeAreaInset(edge: .top) {
                sortPicker
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    router.push(.trips)
                } label: {
                    Text("У списку подорожей: \(viewModel.tripCount)")
                        .font(.footnote)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                }
                .background(.bar)
            }
            .task {
                await viewModel.loadIfNeeded()
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let message = viewModel.errorMessage {
            Text(message)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(viewModel.countries) { country in
                CountryRowView(
                    country: country,
                    isInTrips: viewModel.isInTrips(country),
                    onOpen: { router.push(.countryDetail(country)) },
                    onToggle: { viewModel.toggleTrip(country) }
                )
            }
            .listStyle(.plain)
        }
    }

    private var sortPicker: some View {
        Picker("Сортування", selection: $viewModel.selectedSortIndex) {
            ForEach(viewModel.sortStrategies.indices, id: \.self) { index in
                Text(viewModel.sortStrategies[index].title).tag(index)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.bar)
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
