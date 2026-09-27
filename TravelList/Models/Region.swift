import Foundation

enum Region: String, CaseIterable {
    case europeCentralAsia = "ECS"
    case eastAsiaPacific = "EAS"
    case southAsia = "SAS"
    case middleEastNorthAfrica = "MEA"
    case subSaharanAfrica = "SSF"
    case northAmerica = "NAC"
    case latinAmerica = "LCN"
    case antarctica = "ANT"

    var title: String {
        switch self {
        case .europeCentralAsia: return "Європа та Центральна Азія"
        case .eastAsiaPacific: return "Східна Азія та Океанія"
        case .southAsia: return "Південна Азія"
        case .middleEastNorthAfrica: return "Близький Схід, Північна Африка, Афганістан і Пакистан"
        case .subSaharanAfrica: return "Африка на південь від Сахари"
        case .northAmerica: return "Північна Америка"
        case .latinAmerica: return "Латинська Америка"
        case .antarctica: return "Антарктида"
        }
    }
}
