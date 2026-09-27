import SwiftUI

struct TripsView: View {
    @StateObject private var viewModel: TripsViewModel
    @EnvironmentObject private var router: AppRouter

    init(viewModel: @autoclosure @escaping () -> TripsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        Group {
            if viewModel.items.isEmpty {
                ContentUnavailableView(
                    "Список порожній",
                    systemImage: "suitcase",
                    description: Text("Додайте країни на екрані «Країни»")
                )
            } else {
                List {
                    ForEach(TripStatus.allCases, id: \.self) { status in
                        section(for: status)
                    }
                }
            }
        }
        .navigationTitle("Мої подорожі")
        .toolbar {
            Button("На головну") {
                router.popToRoot()
            }
        }
    }

    @ViewBuilder
    private func section(for status: TripStatus) -> some View {
        let items = viewModel.items(with: status)
        if !items.isEmpty {
            Section(status.title) {
                ForEach(items) { item in
                    Button {
                        router.push(.countryDetail(item.country))
                    } label: {
                        row(for: item)
                    }
                    .swipeActions {
                        Button("Видалити", role: .destructive) {
                            viewModel.remove(item)
                        }
                    }
                }
            }
        }
    }

    private func row(for item: TripItem) -> some View {
        HStack(spacing: 12) {
            Text(item.country.flag)
                .font(.title)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.country.name)
                    .font(.headline)
                if let note = item.note {
                    Text(note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .foregroundStyle(.primary)
        .contentShape(Rectangle())
    }
}
