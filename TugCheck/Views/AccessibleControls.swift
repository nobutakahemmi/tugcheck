import SwiftUI
import UIKit

struct LargeButton: View {
    let title: String
    var hint: String?
    var role: ButtonRole?
    var prominent: Bool = false
    var tint: Color?
    let action: () -> Void

    var body: some View {
        styled
            .accessibilityLabel(title)
            .modifier(OptionalAccessibilityHint(hint: hint))
    }

    private var buttonLabel: some View {
        Text(title)
            .font(.title3)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, minHeight: 60)
    }

    @ViewBuilder
    private var styled: some View {
        if prominent {
            if let tint {
                Button(role: role, action: action, label: { buttonLabel })
                    .buttonStyle(.borderedProminent)
                    .tint(tint)
            } else {
                Button(role: role, action: action, label: { buttonLabel })
                    .buttonStyle(.borderedProminent)
            }
        } else if let tint {
            Button(role: role, action: action, label: { buttonLabel })
                .buttonStyle(.bordered)
                .tint(tint)
        } else {
            Button(role: role, action: action, label: { buttonLabel })
                .buttonStyle(.bordered)
        }
    }
}

struct CheckButton: View {
    let title: String
    let hint: String?
    let isOn: Bool
    let action: () -> Void

    @Environment(\.colorSchemeContrast) private var contrast

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .frame(minWidth: 28, minHeight: 28)
                    .accessibilityHidden(true)
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(8)
            .frame(minHeight: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary, lineWidth: borderWidth)
        )
        .accessibilityLabel(title)
        .accessibilityAddTraits(isOn ? .isSelected : [])
        .accessibilityRemoveTraits(isOn ? [] : .isSelected)
        .modifier(OptionalAccessibilityHint(hint: hint))
    }

    private var borderWidth: CGFloat {
        if contrast == .increased {
            return isOn ? 3 : 2
        }
        return isOn ? 2 : 1
    }
}

struct BorderedField: ViewModifier {
    @Environment(\.colorSchemeContrast) private var contrast

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 12)
            .frame(minHeight: 60)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary, lineWidth: contrast == .increased ? 2 : 1)
            )
    }
}

struct OptionalAccessibilityHint: ViewModifier {
    let hint: String?

    @ViewBuilder
    func body(content: Content) -> some View {
        if let hint, !hint.isEmpty {
            content.accessibilityHint(hint)
        } else {
            content
        }
    }
}

extension View {
    func borderedField() -> some View {
        modifier(BorderedField())
    }
}
