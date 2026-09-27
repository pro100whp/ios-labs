import Foundation

enum WorldBankCountryMapper {
    static func map(
        countries: [WorldBankCountryDTO],
        population: [WorldBankIndicatorDTO],
        area: [WorldBankIndicatorDTO]
    ) -> [Country] {
        let populationByCode = valuesByCountry(population)
        let areaByCode = valuesByCountry(area)

        return countries.compactMap { dto in
            guard let region = Region(rawValue: dto.region.id) else {
                return nil
            }
            let capital = dto.capitalCity.trimmingCharacters(in: .whitespaces)
            return Country(
                id: dto.id,
                name: dto.name,
                capital: capital.isEmpty ? nil : capital,
                region: region,
                population: Int(populationByCode[dto.id] ?? 0),
                area: areaByCode[dto.id] ?? 0,
                flag: flagEmoji(for: dto.iso2Code)
            )
        }
    }

    static func flagEmoji(for isoCode: String) -> String {
        let letters = isoCode.uppercased().unicodeScalars
        guard letters.count == 2, letters.allSatisfy({ $0.value >= 65 && $0.value <= 90 }) else {
            return "🏳️"
        }
        var flag = ""
        for letter in letters {
            if let scalar = Unicode.Scalar(127_397 + letter.value) {
                flag.unicodeScalars.append(scalar)
            }
        }
        return flag
    }

    private static func valuesByCountry(_ items: [WorldBankIndicatorDTO]) -> [String: Double] {
        var result: [String: Double] = [:]
        for item in items {
            if let value = item.value, result[item.countryiso3code] == nil {
                result[item.countryiso3code] = value
            }
        }
        return result
    }
}
