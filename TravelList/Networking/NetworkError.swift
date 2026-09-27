import Foundation

enum NetworkError: Error {
    case invalidURL
    case transport(Error)
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)

    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Некоректна адреса запиту."
        case .transport:
            return "Немає з'єднання з сервером. Перевірте інтернет і спробуйте ще раз."
        case .invalidResponse:
            return "Сервер повернув некоректну відповідь."
        case .httpStatus(let code):
            return "Сервер повернув помилку (код \(code)). Спробуйте пізніше."
        case .decoding:
            return "Не вдалося обробити дані від сервера."
        }
    }
}
