import Foundation

struct StubTransport: HTTPTransport {
    enum Behavior {
        case json(String)
        case status(Int)
        case failure(URLError.Code)
    }

    static let emptyResponse = #"[{"page":1,"pages":1,"per_page":"400","total":0},[]]"#
    static let invalidResponse = #"{"message":"unexpected format"}"#

    let behavior: Behavior
    var delayNanoseconds: UInt64 = 500_000_000

    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await Task.sleep(nanoseconds: delayNanoseconds)
        switch behavior {
        case .json(let body):
            return (Data(body.utf8), try makeResponse(for: request, statusCode: 200))
        case .status(let code):
            return (Data(), try makeResponse(for: request, statusCode: code))
        case .failure(let code):
            throw URLError(code)
        }
    }

    private func makeResponse(for request: URLRequest, statusCode: Int) throws -> HTTPURLResponse {
        guard
            let url = request.url,
            let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: nil)
        else {
            throw URLError(.badServerResponse)
        }
        return response
    }
}
