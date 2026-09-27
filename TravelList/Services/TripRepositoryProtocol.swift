import Combine
import Foundation

protocol TripRepositoryProtocol: AnyObject {
    var items: [TripItem] { get }
    var itemsPublisher: AnyPublisher<[TripItem], Never> { get }
    func add(_ country: Country) -> Bool
    func save(country: Country, status: TripStatus, note: String?)
    func remove(countryId: String)
    func item(for countryId: String) -> TripItem?
    func contains(countryId: String) -> Bool
}
