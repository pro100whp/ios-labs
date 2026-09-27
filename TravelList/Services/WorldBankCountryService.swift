import Foundation

struct WorldBankCountryService: CountryServiceProtocol {
    private let client: any NetworkClientProtocol

    init(client: any NetworkClientProtocol) {
        self.client = client
    }

    func fetchCountries() async throws -> [Country] {
        async let countriesPage: WorldBankPage<WorldBankCountryDTO> = client.get(WorldBankEndpoint.countries)
        async let populationPage: WorldBankPage<WorldBankIndicatorDTO> = client.get(WorldBankEndpoint.indicator(.population))
        async let areaPage: WorldBankPage<WorldBankIndicatorDTO> = client.get(WorldBankEndpoint.indicator(.area))

        let (countries, population, area) = try await (countriesPage, populationPage, areaPage)

        return WorldBankCountryMapper.map(
            countries: countries.items,
            population: population.items,
            area: area.items
        )
    }
}
