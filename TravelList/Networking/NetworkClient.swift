import Foundation

protocol HTTPTransport {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPTransport {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}

protocol NetworkClientProtocol {
    func get<T: Decodable>(_ endpoint: any Endpoint) async throws -> T
}

struct NetworkClient: NetworkClientProtocol {
    private let transport: any HTTPTransport
    private let decoder: JSONDecoder

    init(transport: any HTTPTransport = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.transport = transport
        self.decoder = decoder
    }

    func get<T: Decodable>(_ endpoint: any Endpoint) async throws -> T {
        let request = try endpoint.makeRequest()

        let result: (Data, URLResponse)
        do {
            result = try await transport.send(request)
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw NetworkError.transport(error)
        }
        let (data, response) = result

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpStatus(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
