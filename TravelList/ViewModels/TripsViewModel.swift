import Combine
import Foundation

final class TripsViewModel: ObservableObject {
    @Published private(set) var items: [TripItem] = []

    private let tripRepository: any TripRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(tripRepository: any TripRepositoryProtocol) {
        self.tripRepository = tripRepository
        tripRepository.itemsPublisher
            .sink { [weak self] items in
                self?.items = items
            }
            .store(in: &cancellables)
    }

    func items(with status: TripStatus) -> [TripItem] {
        items.filter { $0.status == status }
    }

    func remove(_ item: TripItem) {
        tripRepository.remove(countryId: item.country.id)
    }
}
