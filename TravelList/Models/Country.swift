import Foundation

struct Country: Identifiable, Hashable {
    let id: String
    let name: String
    let capital: String?
    let region: Region
    let population: Int
    let area: Double
    let flag: String

    var populationText: String {
        population > 0 ? population.formatted() : "—"
    }
}

extension Country: Describable {
    var summary: String {
        let capitalText = capital ?? "без столиці"
        return "\(flag) \(name) — \(capitalText), \(region.title)"
    }
}
