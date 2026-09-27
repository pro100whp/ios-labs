import SwiftUI

struct CountryDetailView: View {
    @StateObject private var viewModel: CountryDetailViewModel
    @EnvironmentObject private var router: AppRouter
    @State private var isExpanded = false

    init(viewModel: @autoclosure @escaping () -> CountryDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                infoCard
                tripCard
            }
            .padding()
        }
        .navigationTitle(viewModel.country.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text(viewModel.country.flag)
                .font(.system(size: 96))
            Text(viewModel.country.name)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
            Text(viewModel.country.region.title)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow(title: "Столиця", value: viewModel.capitalText)
            infoRow(title: "Населення", value: viewModel.country.populationText)

            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    infoRow(title: "Площа", value: viewModel.areaText)
                    infoRow(title: "Густота", value: viewModel.densityText)
                    infoRow(title: "Код країни", value: viewModel.country.id)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(isExpanded ? "Згорнути" : "Детальніше")
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .font(.subheadline.weight(.semibold))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
        .clipped()
    }

    private var tripCard: some View {
        VStack(spacing: 12) {
            if let item = viewModel.tripItem {
                HStack(alignment: .top, spacing: 12) {
                    Text(item.status.icon)
                        .font(.title)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.status.title)
                            .font(.headline)
                        if let note = item.note {
                            Text(note)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    Spacer(minLength: 0)
                }
                .transition(.scale.combined(with: .opacity))

                Button {
                    router.present(.tripForm(viewModel.country))
                } label: {
                    Label("Редагувати", systemImage: "pencil")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            } else {
                Button {
                    router.present(.tripForm(viewModel.country))
                } label: {
                    Label("Додати до подорожей", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
        .animation(.spring(response: 0.45, dampingFraction: 0.7), value: viewModel.tripItem?.status)
        .animation(.easeInOut(duration: 0.25), value: viewModel.tripItem?.note)
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer(minLength: 12)
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}
