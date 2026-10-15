import SwiftUI

private enum DarkStyle {
    static let background = Color(red: 0.035, green: 0.043, blue: 0.065)
    static let card = Color(red: 0.075, green: 0.09, blue: 0.13)
    static let blue = Color(red: 0.12, green: 0.48, blue: 1.0)
    static let muted = Color(red: 0.53, green: 0.59, blue: 0.69)
}

private enum GameTarget: String, CaseIterable, Identifiable {
    case ffm = "FFM"
    case fft = "FFT"

    var id: String { rawValue }

    var bundleID: String {
        switch self {
        case .ffm: return "com.dts.freefiremax"
        case .fft: return "com.dts.freefireth"
        }
    }
}

private enum FeatureCategory: String, CaseIterable, Identifiable {
    case aim = "AIM"
    case esp = "ESP"
    case threeD = "3D"
    case modSkin = "MOD SKIN"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .aim: return "scope"
        case .esp: return "viewfinder"
        case .threeD: return "cube.transparent"
        case .modSkin: return "tshirt"
        }
    }

    var options: [String] {
        switch self {
        case .aim:
            return ["Aim Speed", "Aim Precision", "Aim Control"]
        case .esp:
            return ["ESP Box", "ESP Line", "ESP Distance"]
        case .threeD:
            return ["3D View", "3D Box", "3D Outline"]
        case .modSkin:
            return ["Skin Option 1", "Skin Option 2", "Skin Option 3"]
        }
    }
}

struct ContentView: View {
    @State private var selectedGame: GameTarget = .ffm

    // كل قسم له اختيار مستقل.
    @State private var selectedOptions: [FeatureCategory: String] = [:]

    @State private var activeMessage: String?
    @State private var showMessage = false

    var body: some View {
        ZStack {
            DarkStyle.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    header
                    gameSelector

                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("FEATURES")
                                .font(.system(size: 21, weight: .bold))
                                .tracking(2)

                            Text("Choose one option in each section")
                                .font(.system(size: 12))
                                .foregroundStyle(DarkStyle.muted)
                        }

                        Spacer()

                        Circle()
                            .fill(Color.green)
                            .frame(width: 7, height: 7)

                        Text("READY")
                            .font(.system(size: 10, weight: .bold))
                            .tracking(1)
                            .foregroundStyle(.green)
                    }

                    ForEach(FeatureCategory.allCases) { category in
                        featureCard(category)
                    }

                    Button {
                        activeMessage =
                            "Selected target: \(selectedGame.rawValue)\n" +
                            "Bundle ID: \(selectedGame.bundleID)\n\n" +
                            selectionSummary
                        showMessage = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("REVIEW SELECTION")
                                .tracking(1.5)
                        }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(DarkStyle.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)

                    Text("DARK • iOS")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .foregroundStyle(DarkStyle.muted)
                        .padding(.top, 4)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .preferredColorScheme(.dark)
        .alert("DARK", isPresented: $showMessage) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(activeMessage ?? "")
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 13)
                    .fill(DarkStyle.blue.opacity(0.15))
                    .frame(width: 48, height: 48)

                Image(systemName: "bolt.fill")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundStyle(DarkStyle.blue)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("DARK")
                    .font(.system(size: 28, weight: .black))
                    .tracking(4)

                Text("FEATURE CONTROL")
                    .font(.system(size: 9, weight: .semibold))
                    .tracking(2.2)
                    .foregroundStyle(DarkStyle.muted)
            }

            Spacer()

            Text("V1.0")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(DarkStyle.blue)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(DarkStyle.blue.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(.bottom, 4)
    }

    private var gameSelector: some View {
        HStack(spacing: 12) {
            ForEach(GameTarget.allCases) { game in
                let isSelected = selectedGame == game

                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        selectedGame = game
                    }
                } label: {
                    VStack(spacing: 8) {
                        Text(game.rawValue)
                            .font(.system(size: 19, weight: .black))
                            .tracking(2)

                        Text(game == .ffm ? "FREE FIRE MAX" : "FREE FIRE")
                            .font(.system(size: 9, weight: .medium))
                            .tracking(1)
                            .foregroundStyle(
                                isSelected ? .white.opacity(0.75) : DarkStyle.muted
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 19)
                    .background(
                        isSelected ? DarkStyle.blue.opacity(0.2) : DarkStyle.card
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                isSelected ? DarkStyle.blue : Color.white.opacity(0.06),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .buttonStyle(.plain)
                .foregroundStyle(isSelected ? DarkStyle.blue : .white)
            }
        }
    }

    private func featureCard(_ category: FeatureCategory) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 11) {
                Image(systemName: category.icon)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(DarkStyle.blue)
                    .frame(width: 39, height: 39)
                    .background(DarkStyle.blue.opacity(0.13))
                    .clipShape(RoundedRectangle(cornerRadius: 11))

                VStack(alignment: .leading, spacing: 3) {
                    Text(category.rawValue)
                        .font(.system(size: 15, weight: .bold))
                        .tracking(1.2)

                    Text("Select one feature")
                        .font(.system(size: 11))
                        .foregroundStyle(DarkStyle.muted)
                }

                Spacer()

                Text(selectedOptions[category] == nil ? "0 SELECTED" : "1 SELECTED")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(
                        selectedOptions[category] == nil
                            ? DarkStyle.muted : DarkStyle.blue
                    )
            }

            VStack(spacing: 8) {
                ForEach(category.options, id: \.self) { option in
                    let isSelected = selectedOptions[category] == option

                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            // الاختيار داخل القسم الحالي فقط.
                            selectedOptions[category] =
                                isSelected ? nil : option
                        }
                    } label: {
                        HStack {
                            Text(option)
                                .font(.system(size: 13, weight: .medium))

                            Spacer()

                            Image(
                                systemName: isSelected
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                            .font(.system(size: 17))
                            .foregroundStyle(
                                isSelected ? DarkStyle.blue : DarkStyle.muted
                            )
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 13)
                        .background(
                            isSelected
                                ? DarkStyle.blue.opacity(0.12)
                                : Color.white.opacity(0.025)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    isSelected
                                        ? DarkStyle.blue.opacity(0.7)
                                        : Color.white.opacity(0.05),
                                    lineWidth: 1
                                )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }

            Button {
                let option = selectedOptions[category]

                if let option {
                    activeMessage =
                        "\(category.rawValue)\n" +
                        "Game: \(selectedGame.rawValue)\n" +
                        "Feature: \(option)\n\n" +
                        "The injection action is not connected yet."
                } else {
                    activeMessage =
                        "Choose one option in \(category.rawValue) first."
                }

                showMessage = true
            } label: {
                HStack(spacing: 9) {
                    Image(systemName: "bolt.fill")
                    Text("INJECT")
                        .tracking(2)
                }
                .font(.system(size: 12, weight: .heavy))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(DarkStyle.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(DarkStyle.card)
        .clipShape(RoundedRectangle(cornerRadius: 17))
        .overlay {
            RoundedRectangle(cornerRadius: 17)
                .stroke(Color.white.opacity(0.055), lineWidth: 1)
        }
    }

    private var selectionSummary: String {
        FeatureCategory.allCases.map { category in
            "\(category.rawValue): \(selectedOptions[category] ?? "None")"
        }
        .joined(separator: "\n")
    }
}
