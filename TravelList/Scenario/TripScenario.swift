import Foundation

struct TripScenario {
    private var log: [String] = []

    mutating func run() -> [String] {
        log = []
        let tripList = TripList(title: "Мої подорожі")

        write("1. Додаємо країни до списку")
        let plannedIds = ["JPN", "ITA", "POL", "CAN", "ATA"]
        for id in plannedIds {
            guard let country = SampleCountries.country(id: id) else {
                write("   Країну \(id) не знайдено")
                continue
            }
            tripList.add(country)
            write("   + \(country.summary)")
        }

        write("2. Повторне додавання")
        if let japan = SampleCountries.country(id: "JPN") {
            let added = tripList.add(japan)
            write(added ? "   Японію додано вдруге" : "   Японія вже є у списку")
        }

        write("3. Позначаємо Польщу як відвідану")
        let isMarked = tripList.markVisited(countryId: "POL")
        write(isMarked ? "   Статус змінено" : "   Країну не знайдено")

        write("4. Фільтрація за статусом")
        for status in TripStatus.allCases {
            let names = tripList.items(with: status).map { $0.country.name }
            write("   \(status.title): \(names.joined(separator: ", "))")
        }

        write("5. Фільтрація за регіоном: Європа та Центральна Азія")
        for item in tripList.items(in: .europeCentralAsia) {
            write("   \(item.summary)")
        }

        write("6. Робота з optional")
        let franceItem = tripList.item(for: "FRA")
        write("   Франція у списку: \(franceItem?.country.name ?? "немає")")
        if let antarctica = tripList.item(for: "ATA") {
            write("   Столиця Антарктиди: \(antarctica.country.capital ?? "відсутня")")
        }

        write("7. Struct копіюється, class передається за посиланням")
        if var copy = tripList.item(for: "ITA") {
            copy.note = "Рим і Флоренція"
            let original = tripList.item(for: "ITA")
            write("   Нотатка копії: \(copy.note ?? "-"), оригіналу: \(original?.note ?? "-")")
        }
        let sameList = tripList
        sameList.remove(countryId: "ATA")
        write("   Після видалення через іншу змінну: \(tripList.count) країн")

        write("8. Підсумок")
        write("   \(tripList.summary)")
        write("   Населення країн у списку: \(tripList.totalPopulation.formatted())")

        return log
    }

    private mutating func write(_ line: String) {
        print(line)
        log.append(line)
    }
}
