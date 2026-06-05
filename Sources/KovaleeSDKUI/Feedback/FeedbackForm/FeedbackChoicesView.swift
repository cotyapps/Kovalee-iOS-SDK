#if os(iOS)
import SwiftUI

@available(iOS 17, *)
public struct FeedbackChoicesView: View {
    let title: String
    let subtitle: String
    let choices: [String]
    let titleColor: Color
    let subtitleColor: Color
    let background: Color
    let cardBackground: Color
    let ctaColor: Color
    let selectedBackground: Color
    let selectedText: Color
    let unselectedText: Color
    let titleFont: Font
    let subtitleFont: Font
    let buttonFont: Font
    let buttonTitle: String
    let buttonCornerRadius: CGFloat
    let onSubmit: ([String]) -> Void

    @State private var selectedChoices: Set<String>

    public init(
        title: String,
        subtitle: String,
        choices: [String],
        titleColor: Color,
        subtitleColor: Color,
        background: Color,
        cardBackground: Color,
        ctaColor: Color,
        selectedBackground: Color,
        selectedText: Color,
        unselectedText: Color,
        titleFont: Font,
        subtitleFont: Font,
        buttonFont: Font,
        buttonTitle: String,
        buttonCornerRadius: CGFloat = 16,
        initialSelection: Set<String> = [],
        onSubmit: @escaping ([String]) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.choices = choices
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.background = background
        self.cardBackground = cardBackground
        self.ctaColor = ctaColor
        self.selectedBackground = selectedBackground
        self.selectedText = selectedText
        self.unselectedText = unselectedText
        self.titleFont = titleFont
        self.subtitleFont = subtitleFont
        self.buttonFont = buttonFont
        self.buttonTitle = buttonTitle
        self.buttonCornerRadius = buttonCornerRadius
        self.onSubmit = onSubmit
        self._selectedChoices = State(initialValue: initialSelection)
    }

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(titleFont)
                        .foregroundColor(titleColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(subtitle)
                        .font(subtitleFont)
                        .foregroundColor(subtitleColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 24)

                    LazyVStack(spacing: 16) {
                        ForEach(choices, id: \.self) { choice in
                            ChoiceRow(
                                text: choice,
                                isSelected: selectedChoices.contains(choice),
                                cardBackground: cardBackground,
                                selectedBackground: selectedBackground,
                                selectedText: selectedText,
                                unselectedText: unselectedText,
                                ctaColor: ctaColor,
                                font: buttonFont,
                                onTap: { toggle(choice) }
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }

            footer
        }
        .background(background)
    }

    // MARK: - Footer (helper + CTA)

    private var footer: some View {
        VStack(spacing: 12) {
            Button(action: { onSubmit(Array(selectedChoices)) }) {
                Text(buttonTitle)
                    .font(buttonFont)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ctaColor)
                    .clipShape(RoundedRectangle(cornerRadius: buttonCornerRadius))
            }
            .disabled(selectedChoices.isEmpty)
            .opacity(selectedChoices.isEmpty ? 0.5 : 1)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(background)
    }

    // MARK: - Helpers

    private func toggle(_ choice: String) {
        if selectedChoices.contains(choice) {
            selectedChoices.remove(choice)
        }
        else {
            selectedChoices.insert(choice)
        }
    }
}

// MARK: - Choice row

@available(iOS 17, *)
private struct ChoiceRow: View {
    let text: String
    let isSelected: Bool
    let cardBackground: Color
    let selectedBackground: Color
    let selectedText: Color
    let unselectedText: Color
    let ctaColor: Color
    let font: Font
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Text(text)
                    .font(font)
                    .foregroundColor(isSelected ? selectedText : unselectedText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                selectionControl
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 22)
            .background(isSelected ? selectedBackground : cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? ctaColor : Color.clear, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var selectionControl: some View {
        ZStack {
            if isSelected {
                Circle().fill(ctaColor)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
            else {
                Circle().stroke(unselectedText.opacity(0.25), lineWidth: 1.5)
            }
        }
        .frame(width: 24, height: 24)
    }
}
#endif
