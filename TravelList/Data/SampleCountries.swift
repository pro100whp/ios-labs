import Foundation

enum SampleCountries {
    static let all: [Country] = [
        Country(id: "UKR", name: "Україна", capital: "Київ", region: .europe, population: 37_000_000, area: 603_550, flag: "🇺🇦"),
        Country(id: "POL", name: "Польща", capital: "Варшава", region: .europe, population: 37_950_000, area: 312_696, flag: "🇵🇱"),
        Country(id: "ITA", name: "Італія", capital: "Рим", region: .europe, population: 58_990_000, area: 301_336, flag: "🇮🇹"),
        Country(id: "JPN", name: "Японія", capital: "Токіо", region: .asia, population: 124_500_000, area: 377_930, flag: "🇯🇵"),
        Country(id: "EGY", name: "Єгипет", capital: "Каїр", region: .africa, population: 105_000_000, area: 1_002_450, flag: "🇪🇬"),
        Country(id: "CAN", name: "Канада", capital: "Оттава", region: .americas, population: 40_100_000, area: 9_984_670, flag: "🇨🇦"),
        Country(id: "AUS", name: "Австралія", capital: "Канберра", region: .oceania, population: 26_600_000, area: 7_692_024, flag: "🇦🇺"),
        Country(id: "ATA", name: "Антарктида", capital: nil, region: .antarctic, population: 1_000, area: 14_000_000, flag: "🇦🇶")
    ]

    static func country(id: String) -> Country? {
        all.first { $0.id == id }
    }
}
