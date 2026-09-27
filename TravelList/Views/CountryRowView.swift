import SwiftUI

struct CountryRowView: View {
    let country: Country
    let isInTrips: Bool
    let onOpen: () -> Void
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onOpen) {
                HStack(spacing: 12) {
                    Text(country.flag)
                        .font(.largeTitle)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(country.name)
                            .font(.headline)
                        Text(country.capital ?? "Без столиці")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 0)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button(action: onToggle) {
                Image(systemName: isInTrips ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundStyle(isInTrips ? Color.red : Color.gray)
                    .scaleEffect(isInTrips ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.45), value: isInTrips)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.borderless)
            .accessibilityLabel(isInTrips ? "Прибрати зі списку" : "Додати до списку")
        }
        .padding(.vertical, 2)
    }
}
