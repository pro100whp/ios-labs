import SwiftUI

struct CountryRowView: View {
    let country: Country
    let isInTrips: Bool
    let onToggle: () -> Void

    var body: some View {
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
            Spacer()
            Button(action: onToggle) {
                Image(systemName: isInTrips ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundStyle(isInTrips ? Color.red : Color.gray)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
    }
}
