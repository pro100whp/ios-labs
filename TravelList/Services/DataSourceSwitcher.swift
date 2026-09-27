import Combine
import Foundation

enum DataSource: String, CaseIterable, Identifiable {
    case live
    case local
    case empty
    case transportError
    case httpError
    case decodingError

    var id: String { rawValue }

    var title: String {
        switch self {
        case .live: return "Реальне API"
        case .local: return "Локальні дані"
        case .empty: return "Порожня відповідь"
        case .transportError: return "Немає мережі"
        case .httpError: return "Помилка сервера 500"
        case .decodingError: return "Некоректний JSON"
        }
    }
}

final class DataSourceSwitcher: ObservableObject, CountryServiceProtocol {
    @Published var source: DataSource
    private let services: [DataSource: any CountryServiceProtocol]

    init(source: DataSource, services: [DataSource: any CountryServiceProtocol]) {
        self.source = source
        self.services = services
    }

    var availableSources: [DataSource] {
        DataSource.allCases.filter { services[$0] != nil }
    }

    func fetchCountries() async throws -> [Country] {
        guard let service = services[source] else {
            throw NetworkError.invalidResponse
        }
        return try await service.fetchCountries()
    }
}
