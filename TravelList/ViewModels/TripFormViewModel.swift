import Combine
import Foundation

final class TripFormViewModel: ObservableObject {
    let country: Country
    let isEditing: Bool
    @Published var status: TripStatus
    @Published var note: String

    private let tripRepository: any TripRepositoryProtocol

    init(country: Country, tripRepository: any TripRepositoryProtocol) {
        self.country = country
        self.tripRepository = tripRepository
        let existingItem = tripRepository.item(for: country.id)
        self.isEditing = existingItem != nil
        self.status = existingItem?.status ?? .wantToVisit
        self.note = existingItem?.note ?? ""
    }

    var title: String {
        isEditing ? "Редагування" : "Нова подорож"
    }

    func save() {
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        tripRepository.save(
            country: country,
            status: status,
            note: trimmedNote.isEmpty ? nil : trimmedNote
        )
    }

    func delete() {
        tripRepository.remove(countryId: country.id)
    }
}
