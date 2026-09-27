import Foundation

protocol TripRepositoryProtocol: AnyObject {
    var items: [TripItem] { get }
    func add(_ country: Country) -> Bool
    func remove(countryId: String)
    func contains(countryId: String) -> Bool
}
