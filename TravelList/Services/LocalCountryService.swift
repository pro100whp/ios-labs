import Foundation

struct LocalCountryService: CountryServiceProtocol {
    func fetchCountries() async throws -> [Country] {
        SampleCountries.all
    }
}
