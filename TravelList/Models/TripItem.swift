import Foundation

struct TripItem: Identifiable {
    let id = UUID()
    let country: Country
    var status: TripStatus
    var note: String?

    init(country: Country, status: TripStatus = .wantToVisit, note: String? = nil) {
        self.country = country
        self.status = status
        self.note = note
    }

    mutating func markVisited() {
        status = .visited
    }
}

extension TripItem: Describable {
    var summary: String {
        var text = "\(status.icon) \(country.flag) \(country.name)"
        if let note, !note.isEmpty {
            text += " — \(note)"
        }
        return text
    }
}
