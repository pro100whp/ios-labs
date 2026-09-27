import Foundation

final class AppFactory {
    let dataSourceSwitcher: DataSourceSwitcher
    private let tripRepository: any TripRepositoryProtocol

    init(dataSourceSwitcher: DataSourceSwitcher, tripRepository: any TripRepositoryProtocol) {
        self.dataSourceSwitcher = dataSourceSwitcher
        self.tripRepository = tripRepository
    }

    static func live() -> AppFactory {
        let liveService = LoggingCountryService(
            wrapping: WorldBankCountryService(client: NetworkClient())
        )
        let switcher = DataSourceSwitcher(
            source: .live,
            services: [
                .live: liveService,
                .local: LocalCountryService(),
                .empty: stubService(.json(StubTransport.emptyResponse)),
                .transportError: stubService(.failure(.notConnectedToInternet)),
                .httpError: stubService(.status(500)),
                .decodingError: stubService(.json(StubTransport.invalidResponse))
            ]
        )
        return AppFactory(dataSourceSwitcher: switcher, tripRepository: InMemoryTripRepository())
    }

    static func demo() -> AppFactory {
        let switcher = DataSourceSwitcher(
            source: .local,
            services: [.local: DemoCountryService()]
        )
        return AppFactory(dataSourceSwitcher: switcher, tripRepository: InMemoryTripRepository())
    }

    private static func stubService(_ behavior: StubTransport.Behavior) -> any CountryServiceProtocol {
        WorldBankCountryService(client: NetworkClient(transport: StubTransport(behavior: behavior)))
    }

    func makeCountryListViewModel() -> CountryListViewModel {
        CountryListViewModel(countryService: dataSourceSwitcher, tripRepository: tripRepository)
    }

    func makeCountryDetailViewModel(country: Country) -> CountryDetailViewModel {
        CountryDetailViewModel(country: country, tripRepository: tripRepository)
    }

    func makeTripsViewModel() -> TripsViewModel {
        TripsViewModel(tripRepository: tripRepository)
    }

    func makeTripFormViewModel(country: Country) -> TripFormViewModel {
        TripFormViewModel(country: country, tripRepository: tripRepository)
    }
}
