# TravelList

iOS-застосунок для планування подорожей.

## Предметна область

**Призначення:** зберігати список країн, які користувач хоче відвідати або вже відвідав.

**Користувач:** людина, яка планує подорожі й хоче бачити свої плани та відвідані країни в одному місці.

**Основні сценарії:**
- переглянути країни та інформацію про них;
- додати країну до списку подорожей;
- позначити країну як відвідану;
- відфільтрувати список за статусом або регіоном.

**Сутності:**
- `Country` — країна: назва, столиця, регіон, населення, площа, прапор;
- `TripItem` — запис у списку: країна, статус, нотатка;
- `TripList` — список подорожей.

## Конструкції Swift

| Конструкція | Де використано |
|---|---|
| `struct` | `Country`, `TripItem` (`Models/`) |
| `class` | `TripList` (`Models/TripList.swift`) |
| `protocol` | `Describable`, реалізують `Country`, `TripItem`, `TripList` |
| `enum` | `Region`, `TripStatus` |
| `let` / `var` | властивості моделей: `let id`, `var status`, `var note` |
| Властивості, методи, ініціалізація | `TripList`: `init(title:)`, `add`, `markVisited`, `remove`, обчислювані `count`, `totalPopulation` |
| Колекції | `[TripItem]` у `TripList`, `[Country]` у `Data/SampleCountries.swift` |
| Optional | `Country.capital: String?`, `TripItem.note: String?`, `TripList.item(for:) -> TripItem?` |
| Безпечне розгортання | `if let`, `guard let`, `??`, `?.` у `TripScenario` та `TripList` |
| Умовні конструкції | `if`, `guard`, `switch` (`Region`, `TripStatus`), тернарний оператор |
| Обробка колекцій | `filter`, `map`, `reduce`, `first(where:)`, `firstIndex(where:)`, `for-in` |

## Сценарій

`Scenario/TripScenario.swift`:
1. Створюється список `TripList` і до нього додаються країни.
2. Повторне додавання тієї самої країни відхиляється.
3. Польща позначається як відвідана.
4. Список фільтрується за статусом і за регіоном.
5. Пошук відсутньої країни повертає `nil`, який безпечно обробляється.
6. Показано різницю семантики значення (`struct`) і посилання (`class`).
7. Виводиться підсумок списку.

## Запуск

1. Відкрити `TravelList.xcodeproj` у Xcode 16+.
2. Обрати симулятор iPhone і натиснути **Run** (⌘R).

## Перевірка сценарію

Сценарій ПР1 відкривається кнопкою **Демо** на головному екрані. Результат показується на екрані та виводиться в консоль Xcode (**View → Debug Area → Activate Console**). Кнопка **Запустити** виконує сценарій повторно.

## Архітектура (ПР2)

Архітектура — **MVVM**. Схема компонентів, обґрунтування, патерни, SOLID і антипатерни — у [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

```
TravelList/
├── App/          точка входу, AppFactory
├── Models/       Country, TripItem, TripList, Region, TripStatus
├── ViewModels/   CountryListViewModel
├── Views/        CountryListView, CountryRowView, ScenarioLogView
├── Services/     сервіси даних, репозиторій, стратегії сортування
├── Data/         локальні дані
└── Scenario/     сценарій ПР1
```

| Патерн / принцип | Компонент | Призначення |
|---|---|---|
| Factory | `AppFactory` | Створення `ViewModel` і передавання залежностей |
| Decorator | `LoggingCountryService` | Логування запитів без зміни сервісу |
| Strategy | `CountrySortStrategy` | Взаємозамінні алгоритми сортування |
| Observer | `CountryListViewModel` (`@Published`) | Автоматичне оновлення `View` |
| SRP | `View` / `ViewModel` / `Services` | Кожен компонент має одну відповідальність |
| OCP | `CountrySortStrategy`, `LoggingCountryService` | Розширення без зміни наявного коду |
| LSP | реалізації `CountryServiceProtocol` | Взаємозамінні сервіси |
| ISP | `CountryServiceProtocol`, `TripRepositoryProtocol` | Вузькі окремі інтерфейси |
| DIP | `CountryListViewModel` | Залежить від протоколів, отримує їх через `init` |

**Сценарій:** на екрані «Країни» обрати регіон (кнопка зліва вгорі) і сортування (перемикач), натиснути ❤️ біля країни — лічильник «У списку подорожей» унизу оновиться.

**Заміна сервісу на демонстраційний:** у `App/TravelListApp.swift` замінити `AppFactory.live()` на `AppFactory.demo()`.
