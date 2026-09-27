import Foundation

final class CountryListViewModel: ObservableObject {
    @Published private(set) var countries: [Country] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var tripCount = 0
    @Published var selectedRegion: Region? {
        didSet { applyFilters() }
    }
    @Published var selectedSortIndex = 0 {
        didSet { applyFilters() }
    }

    let sortStrategies: [any CountrySortStrategy]
    private var allCountries: [Country] = []
    private let countryService: any CountryServiceProtocol
    private let tripRepository: any TripRepositoryProtocol

    init(
        countryService: any CountryServiceProtocol,
        tripRepository: any TripRepositoryProtocol,
        sortStrategies: [any CountrySortStrategy] = [SortByName(), SortByPopulation(), SortByArea()]
    ) {
        self.countryService = countryService
        self.tripRepository = tripRepository
        self.sortStrategies = sortStrategies
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
        guard sortStrategies.indices.contains(selectedSortIndex) else {
            countries = result
            return
        }
        countries = sortStrategies[selectedSortIndex].sort(result)
    }
}
