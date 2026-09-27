# Практична робота 1. Створення проєкту, Git та основи Swift

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

## Перевірка

Сценарій відкривається кнопкою **Демо** на головному екрані. Результат показується на екрані та виводиться в консоль Xcode (**View → Debug Area → Activate Console**). Кнопка **Запустити** виконує сценарій повторно.
