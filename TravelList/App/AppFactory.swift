import Foundation

final class AppFactory {
    private let countryService: any CountryServiceProtocol
    private let tripRepository: any TripRepositoryProtocol

    init(countryService: any CountryServiceProtocol, tripRepository: any TripRepositoryProtocol) {
        self.countryService = countryService
        self.tripRepository = tripRepository
    }

    static func live() -> AppFactory {
        AppFactory(
            countryService: LoggingCountryService(wrapping: LocalCountryService()),
            tripRepository: InMemoryTripRepository()
        )
    }

    static func demo() -> AppFactory {
        AppFactory(
            countryService: DemoCountryService(),
            tripRepository: InMemoryTripRepository()
        )
    }

    func makeCountryListViewModel() -> CountryListViewModel {
        CountryListViewModel(countryService: countryService, tripRepository: tripRepository)
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
