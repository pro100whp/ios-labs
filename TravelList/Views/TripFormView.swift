import SwiftUI

struct TripFormView: View {
    @StateObject private var viewModel: TripFormViewModel
    @EnvironmentObject private var router: AppRouter
    @FocusState private var isNoteFocused: Bool

    init(viewModel: @autoclosure @escaping () -> TripFormViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 12) {
                        Text(viewModel.country.flag)
                            .font(.largeTitle)
                        Text(viewModel.country.name)
                            .font(.headline)
                    }
                }

                Section("Статус") {
                    Picker("Статус", selection: $viewModel.status) {
                        ForEach(TripStatus.allCases, id: \.self) { status in
                            Text(status.title).tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Нотатка") {
                    TextField("Що хочу побачити або запам'ятати", text: $viewModel.note, axis: .vertical)
                        .lineLimit(3...6)
                        .focused($isNoteFocused)
                }

                if viewModel.isEditing {
                    Section {
                        Button("Видалити зі списку", role: .destructive) {
                            viewModel.delete()
                            router.dismissSheet()
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Скасувати") {
                        router.dismissSheet()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Зберегти") {
                        viewModel.save()
                        router.dismissSheet()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Готово") {
                        isNoteFocused = false
                    }
                }
            }
        }
    }
}
