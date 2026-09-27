import Foundation

protocol Endpoint {
    func makeRequest() throws -> URLRequest
}

enum WorldBankIndicator: String {
    case population = "SP.POP.TOTL"
    case area = "AG.SRF.TOTL.K2"
}

enum WorldBankEndpoint: Endpoint {
    case countries
    case indicator(WorldBankIndicator)

    private static let baseURL = "https://api.worldbank.org/v2"

    private var path: String {
        switch self {
        case .countries:
            return "/country"
        case .indicator(let indicator):
            return "/country/all/indicator/\(indicator.rawValue)"
        }
    }

    private var queryItems: [URLQueryItem] {
        var items = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "per_page", value: "400")
        ]
        if case .indicator = self {
            items.append(URLQueryItem(name: "mrnev", value: "1"))
        }
        return items
    }

    func makeRequest() throws -> URLRequest {
        guard var components = URLComponents(string: Self.baseURL + path) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 20
        return request
    }
}
