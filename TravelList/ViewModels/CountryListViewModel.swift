import Foundation

final class CountryListViewModel: ObservableObject {
    @Published private(set) var countries: [Country] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var tripCount = 0
    @Published var selectedRegion: Region? {
        didSet { applyFilters() }
    }

    private var allCountries: [Country] = []
    private let countryService: any CountryServiceProtocol
    private let tripRepository: any TripRepositoryProtocol

    init(countryService: any CountryServiceProtocol, tripRepository: any TripRepositoryProtocol) {
        self.countryService = countryService
        self.tripRepository = tripRepository
    }

    @MainActor
    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            allCountries = try await countryService.fetchCountries()
            applyFilters()
        } catch {
            errorMessage = "Не вдалося завантажити країни"
        }
        tripCount = tripRepository.items.count
        isLoading = false
    }

    func isInTrips(_ country: Country) -> Bool {
        tripRepository.contains(countryId: country.id)
    }

    func toggleTrip(_ country: Country) {
        if tripRepository.contains(countryId: country.id) {
            tripRepository.remove(countryId: country.id)
        } else {
            _ = tripRepository.add(country)
        }
        tripCount = tripRepository.items.count
    }

    private func applyFilters() {
        var result = allCountries
        if let selectedRegion {
            result = result.filter { $0.region == selectedRegion }
        }
        countries = result.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }
}
