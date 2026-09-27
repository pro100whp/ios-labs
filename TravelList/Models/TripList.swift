import Foundation

final class TripList {
    let title: String
    private(set) var items: [TripItem] = []

    init(title: String) {
        self.title = title
    }

    var count: Int {
        items.count
    }

    var totalPopulation: Int {
        items.reduce(0) { $0 + $1.country.population }
    }

    @discardableResult
    func add(_ country: Country, note: String? = nil) -> Bool {
        if contains(countryId: country.id) {
            return false
        }
        items.append(TripItem(country: country, note: note))
        return true
    }

    @discardableResult
    func markVisited(countryId: String) -> Bool {
        guard let index = items.firstIndex(where: { $0.country.id == countryId }) else {
            return false
        }
        items[index].markVisited()
        return true
    }

    func save(country: Country, status: TripStatus, note: String?) {
        if let index = items.firstIndex(where: { $0.country.id == country.id }) {
            items[index].status = status
            items[index].note = note
        } else {
            items.append(TripItem(country: country, status: status, note: note))
        }
    }

    func remove(countryId: String) {
        items.removeAll { $0.country.id == countryId }
    }

    func item(for countryId: String) -> TripItem? {
        items.first { $0.country.id == countryId }
    }

    func contains(countryId: String) -> Bool {
        item(for: countryId) != nil
    }

    func items(with status: TripStatus) -> [TripItem] {
        items.filter { $0.status == status }
    }

    func items(in region: Region) -> [TripItem] {
        items.filter { $0.country.region == region }
    }
}

extension TripList: Describable {
    var summary: String {
        let visited = items(with: .visited).count
        return "\(title): \(count) країн, відвідано \(visited)"
    }
}
