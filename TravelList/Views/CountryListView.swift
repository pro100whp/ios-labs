import SwiftUI

struct CountryListView: View {
    @ObservedObject var viewModel: CountryListViewModel
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var dataSource: DataSourceSwitcher

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
                    dataSourceMenu
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
            .onChange(of: dataSource.source) {
                Task {
                    await viewModel.load()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Завантаження країн…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .empty:
            ContentUnavailableView {
                Label("Немає даних", systemImage: "globe")
            } description: {
                Text("Сервер не повернув жодної країни.")
            } actions: {
                retryButton
            }
        case .failed(let message):
            ContentUnavailableView {
                Label("Помилка завантаження", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                retryButton
            }
        case .loaded:
            if viewModel.countries.isEmpty {
                ContentUnavailableView(
                    "Немає країн у регіоні",
                    systemImage: "line.3.horizontal.decrease.circle",
                    description: Text("Оберіть інший регіон.")
                )
            } else {
                countryList
            }
        }
    }

    private var retryButton: some View {
        Button("Повторити") {
            Task {
                await viewModel.load()
            }
        }
        .buttonStyle(.borderedProminent)
    }

    private var dataSourceMenu: some View {
        Menu {
            Picker("Джерело даних", selection: $dataSource.source) {
                ForEach(dataSource.availableSources) { source in
                    Text(source.title).tag(source)
                }
            }
        } label: {
            Image(systemName: "antenna.radiowaves.left.and.right")
        }
        .accessibilityLabel("Джерело даних")
    }

    private var countryList: some View {
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
            Label(
                viewModel.selectedRegion?.title ?? "Усі регіони",
                systemImage: viewModel.selectedRegion == nil
                    ? "line.3.horizontal.decrease.circle"
                    : "line.3.horizontal.decrease.circle.fill"
            )
            .labelStyle(.iconOnly)
        }
    }
}
