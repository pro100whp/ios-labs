import Foundation

final class InMemoryTripRepository: TripRepositoryProtocol {
    private let tripList: TripList

    init(tripList: TripList = TripList(title: "Мої подорожі")) {
        self.tripList = tripList
    }

    var items: [TripItem] {
        tripList.items
    }

    func add(_ country: Country) -> Bool {
        tripList.add(country)
    }

    func remove(countryId: String) {
        tripList.remove(countryId: countryId)
    }

    func contains(countryId: String) -> Bool {
        tripList.contains(countryId: countryId)
    }
}
