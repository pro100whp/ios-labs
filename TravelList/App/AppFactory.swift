import Foundation

final class AppFactory {
    private let countryService: any CountryServiceProtocol
    private let tripRepository: any TripRepositoryProtocol

    init(countryService: any CountryServiceProtocol, tripRepository: any TripRepositoryProtocol) {
        self.countryService = countryService
        self.tripRepository = tripRepository
    }

    static func live() -> AppFactory {
        AppFactory(countryService: LocalCountryService(), tripRepository: InMemoryTripRepository())
    }

    func makeCountryListViewModel() -> CountryListViewModel {
        CountryListViewModel(countryService: countryService, tripRepository: tripRepository)
    }
}
