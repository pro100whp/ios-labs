import Foundation

protocol CountryServiceProtocol {
    func fetchCountries() async throws -> [Country]
}
