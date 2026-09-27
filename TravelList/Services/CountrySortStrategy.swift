import Foundation

protocol CountrySortStrategy {
    var title: String { get }
    func sort(_ countries: [Country]) -> [Country]
}

struct SortByName: CountrySortStrategy {
    let title = "Назва"

    func sort(_ countries: [Country]) -> [Country] {
        countries.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }
}

struct SortByPopulation: CountrySortStrategy {
    let title = "Населення"

    func sort(_ countries: [Country]) -> [Country] {
        countries.sorted { $0.population > $1.population }
    }
}

struct SortByArea: CountrySortStrategy {
    let title = "Площа"

    func sort(_ countries: [Country]) -> [Country] {
        countries.sorted { $0.area > $1.area }
    }
}
