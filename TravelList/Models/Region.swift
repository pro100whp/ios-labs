import Foundation

enum Region: String, CaseIterable {
    case europe = "Europe"
    case asia = "Asia"
    case africa = "Africa"
    case americas = "Americas"
    case oceania = "Oceania"
    case antarctic = "Antarctic"

    var title: String {
        switch self {
        case .europe: return "Європа"
        case .asia: return "Азія"
        case .africa: return "Африка"
        case .americas: return "Америка"
        case .oceania: return "Океанія"
        case .antarctic: return "Антарктида"
        }
    }
}
