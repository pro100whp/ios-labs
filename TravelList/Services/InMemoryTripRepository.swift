import Combine
import Foundation

final class InMemoryTripRepository: TripRepositoryProtocol {
    private let tripList: TripList
    private let itemsSubject: CurrentValueSubject<[TripItem], Never>

    init(tripList: TripList = TripList(title: "Мої подорожі")) {
        self.tripList = tripList
        self.itemsSubject = CurrentValueSubject(tripList.items)
    }

    var items: [TripItem] {
        tripList.items
    }

    var itemsPublisher: AnyPublisher<[TripItem], Never> {
        itemsSubject.eraseToAnyPublisher()
    }

    func add(_ country: Country) -> Bool {
        let isAdded = tripList.add(country)
        if isAdded {
            notifyChanges()
        }
        return isAdded
    }

    func save(country: Country, status: TripStatus, note: String?) {
        tripList.save(country: country, status: status, note: note)
        notifyChanges()
    }

    func remove(countryId: String) {
        tripList.remove(countryId: countryId)
        notifyChanges()
    }

    func item(for countryId: String) -> TripItem? {
        tripList.item(for: countryId)
    }

    func contains(countryId: String) -> Bool {
        tripList.contains(countryId: countryId)
    }

    private func notifyChanges() {
        itemsSubject.send(tripList.items)
    }
}
