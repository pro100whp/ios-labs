import Foundation

struct LoggingCountryService: CountryServiceProtocol {
    private let wrapped: any CountryServiceProtocol

    init(wrapping wrapped: any CountryServiceProtocol) {
        self.wrapped = wrapped
    }

    func fetchCountries() async throws -> [Country] {
        print("[CountryService] Запит списку країн")
        do {
            let countries = try await wrapped.fetchCountries()
            print("[CountryService] Отримано країн: \(countries.count)")
            return countries
        } catch {
            print("[CountryService] Помилка: \(error)")
            throw error
        }
    }
}
