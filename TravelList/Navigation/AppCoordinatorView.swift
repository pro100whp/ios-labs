import SwiftUI

struct AppCoordinatorView: View {
    @StateObject private var router = AppRouter()
    @StateObject private var countryListViewModel: CountryListViewModel
    private let factory: AppFactory

    init(factory: AppFactory) {
        self.factory = factory
        _countryListViewModel = StateObject(wrappedValue: factory.makeCountryListViewModel())
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            CountryListView(viewModel: countryListViewModel)
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
        .sheet(item: $router.sheet) { sheet in
            sheetContent(for: sheet)
                .environmentObject(router)
        }
        .environmentObject(router)
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .countryDetail(let country):
            CountryDetailView(viewModel: factory.makeCountryDetailViewModel(country: country))
        case .trips:
            TripsView(viewModel: factory.makeTripsViewModel())
        }
    }

    @ViewBuilder
    private func sheetContent(for sheet: SheetRoute) -> some View {
        switch sheet {
        case .tripForm(let country):
            TripFormView(viewModel: factory.makeTripFormViewModel(country: country))
        case .scenario:
            ScenarioLogView()
        }
    }
}

#Preview {
    AppCoordinatorView(factory: .demo())
}
