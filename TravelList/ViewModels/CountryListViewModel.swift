import Combine
import Foundation

enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case failed(String)
}

final class CountryListViewModel: ObservableObject {
    @Published private(set) var countries: [Country] = []
    @Published private(set) var state: LoadState = .idle
    @Published private(set) var tripCountryIds: Set<String> = []
    @Published var selectedRegion: Region? = nil {
        didSet { applyFilters() }
    }
    @Published var selectedSortIndex = 0 {
        didSet { applyFilters() }
    }

    let sortStrategies: [any CountrySortStrategy]
    private var allCountries: [Country] = []
    private let countryService: any CountryServiceProtocol
    private let tripRepository: any TripRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        countryService: any CountryServiceProtocol,
        tripRepository: any TripRepositoryProtocol,
        sortStrategies: [any CountrySortStrategy] = [SortByName(), SortByPopulation(), SortByArea()]
    ) {
        self.countryService = countryService
        self.tripRepository = tripRepository
        self.sortStrategies = sortStrategies
        observeTrips()
    }

    var tripCount: Int {
        tripCountryIds.count
    }

    @MainActor
    func loadIfNeeded() async {
        guard state == .idle else { return }
        await load()
    }

    @MainActor
    func load() async {
        state = .loading
        do {
            let loadedCountries = try await countryService.fetchCountries()
            allCountries = loadedCountries
            applyFilters()
            state = loadedCountries.isEmpty ? .empty : .loaded
        } catch let error as NetworkError {
            allCountries = []
            applyFilters()
            state = .failed(error.userMessage)
        } catch is CancellationError {
            state = .idle
        } catch {
            allCountries = []
            applyFilters()
            state = .failed("Не вдалося завантажити країни.")
        }
    }

    func isInTrips(_ country: Country) -> Bool {
        tripCountryIds.contains(country.id)
    }

    func toggleTrip(_ country: Country) {
        if tripRepository.contains(countryId: country.id) {
            tripRepository.remove(countryId: country.id)
        } else {
            _ = tripRepository.add(country)
        }
    }

    private func observeTrips() {
        tripRepository.itemsPublisher
            .map { items in Set(items.map { $0.country.id }) }
            .sink { [weak self] ids in
                self?.tripCountryIds = ids
            }
            .store(in: &cancellables)
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
