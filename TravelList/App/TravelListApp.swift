import SwiftUI

@main
struct TravelListApp: App {
    private let factory = AppFactory.live()

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(factory: factory)
        }
    }
}
