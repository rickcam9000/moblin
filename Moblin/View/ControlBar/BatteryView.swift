import SwiftUI

struct BatteryView: View {
    var level: Double

    private func color() -> Color {
        if level < 0.2 {
            return .red
        } else if level < 0.4 {
            return .yellow
        } else {
            return .white
        }
    }

    private func width() -> Double {
        if level >= 0.0 && level <= 1.0 {
            return 17 * level
        } else {
            return 0
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(.gray)
                RoundedRectangle(cornerRadius: 1)
                    .foregroundColor(color())
                    .padding([.leading], 1)
                    .frame(width: width(), height: 8)
            }
            Circle()
                .trim(from: 0.0, to: 0.5)
                .rotationEffect(.degrees(-90))
                .foregroundColor(.gray)
                .frame(width: 4)
        }
        .padding([.top], 1)
        .frame(width: 22, height: 11)
    }
}