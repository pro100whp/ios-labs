import Foundation

struct WorldBankPage<Item: Decodable>: Decodable {
    let total: Int
    let items: [Item]

    private struct Meta: Decodable {
        let page: Int
        let total: Int
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let meta = try container.decode(Meta.self)
        total = meta.total
        if container.isAtEnd {
            items = []
        } else if try container.decodeNil() {
            items = []
        } else {
            items = try container.decode([Item].self)
        }
    }
}

struct WorldBankCountryDTO: Decodable {
    struct Reference: Decodable {
        let id: String
        let value: String
    }

    let id: String
    let iso2Code: String
    let name: String
    let region: Reference
    let capitalCity: String
}

struct WorldBankIndicatorDTO: Decodable {
    let countryiso3code: String
    let value: Double?
}
