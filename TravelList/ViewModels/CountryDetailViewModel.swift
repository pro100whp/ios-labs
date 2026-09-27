import Combine
import Foundation

final class CountryDetailViewModel: ObservableObject {
    let country: Country
    @Published private(set) var tripItem: TripItem? = nil

    private var cancellables = Set<AnyCancellable>()

    init(country: Country, tripRepository: any TripRepositoryProtocol) {
        self.country = country
        let countryId = country.id
        tripRepository.itemsPublisher
            .map { items in items.first { $0.country.id == countryId } }
            .sink { [weak self] item in
                self?.tripItem = item
            }
            .store(in: &cancellables)
    }

    var capitalText: String {
        country.capital ?? "Немає"
    }

    var areaText: String {
        guard country.area > 0 else { return "—" }
        return "\(Int(country.area).formatted()) км²"
    }

    var densityText: String {
        guard country.area > 0, country.population > 0 else { return "—" }
        let density = Double(country.population) / country.area
        return "\(density.formatted(.number.precision(.fractionLength(1)))) осіб/км²"
    }
}
