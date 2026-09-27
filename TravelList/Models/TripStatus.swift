import Foundation

enum TripStatus: String, CaseIterable {
    case wantToVisit
    case visited

    var title: String {
        switch self {
        case .wantToVisit: return "Хочу поїхати"
        case .visited: return "Відвідано"
        }
    }

    var icon: String {
        switch self {
        case .wantToVisit: return "✈️"
        case .visited: return "✅"
        }
    }
}
