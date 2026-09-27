import Combine
import Foundation

enum Route: Hashable {
    case countryDetail(Country)
    case trips
}

enum SheetRoute: Identifiable {
    case tripForm(Country)
    case scenario

    var id: String {
        switch self {
        case .tripForm(let country):
            return "tripForm-\(country.id)"
        case .scenario:
            return "scenario"
        }
    }
}

final class AppRouter: ObservableObject {
    @Published var path: [Route] = []
    @Published var sheet: SheetRoute? = nil

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func present(_ sheet: SheetRoute) {
        self.sheet = sheet
    }

    func dismissSheet() {
        sheet = nil
    }
}
