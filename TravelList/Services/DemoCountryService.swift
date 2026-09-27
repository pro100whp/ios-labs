import Foundation

struct DemoCountryService: CountryServiceProtocol {
    var countries: [Country] = [
        Country(id: "DM1", name: "Демо-країна А", capital: "Столиця А", region: .europe, population: 1_000, area: 100, flag: "🏳️"),
        Country(id: "DM2", name: "Демо-країна Б", capital: nil, region: .asia, population: 5_000, area: 50, flag: "🏴")
    ]

    func fetchCountries() async throws -> [Country] {
        countries
    }
}
