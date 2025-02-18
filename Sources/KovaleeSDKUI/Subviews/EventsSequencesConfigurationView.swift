import KovaleeSDK
import SwiftUI

@available(iOS 16.0, *)
struct EventsSequencesConfigurationView: View {
    enum FocusedField {
        case sequenceVersion
        case parsingLogic
    }

    @FocusState private var focusedField: FocusedField?
    @Binding var isDebugModeOn: Bool

    @State private var sequenceVersionValue: String = "0"
    @State private var parsingLogicValue: String = "0"
    @State private var currentSequencesFileName: String?
    @State private var currentEventsSequence: String?

    var body: some View {
        Group {
            if let fileName = currentSequencesFileName {
                InfoLabel(
                    title: "Loaded file:",
                    value: fileName,
                    horizontal: true
                )
            }

            if let sequence = currentEventsSequence {
                InfoLabel(
                    title: "Current sequence:",
                    value: sequence,
                    horizontal: false
                )
            }

            if isDebugModeOn {
                HStack {
                    Text("Sequence version:").bold()
                    TextField("Sequence version:", text: $sequenceVersionValue)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .sequenceVersion)
                }
                HStack {
                    Text("Parsing logic: ").bold()
                    TextField("Parsing logic", text: $parsingLogicValue)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .parsingLogic)
                }

                Button(action: refreshAction) {
                    Text("Refresh Sequences")
                }
                .buttonStyle(.borderedProminent)
            } else {
                InfoLabel(
                    title: "Sequence version:",
                    value: sequenceVersionValue
                )
                InfoLabel(
                    title: "Parsing Logic:",
                    value: parsingLogicValue
                )
            }
        }
        .onAppear {
            retrieveValues()
        }
    }

    private func retrieveValues() {
        withAnimation {
            if let logic = Kovalee.shared.kovaleeManager?.parsingLogic() {
                parsingLogicValue = String(logic)
            }
            if let sequence = Kovalee.shared.kovaleeManager?.sequenceVersion() {
                sequenceVersionValue = String(sequence)
            }

            currentSequencesFileName = Kovalee.shared.kovaleeManager?.currentSequencesFileName()
            currentEventsSequence = Kovalee.shared.kovaleeManager?.currentEventsSequence()
        }
    }

    private func refreshAction() {
        focusedField = nil

        Kovalee.shared.kovaleeManager?.resetApp()

        Kovalee.shared.kovaleeManager?.setParsingLogic(Int(parsingLogicValue) ?? 0)
        Kovalee.shared.kovaleeManager?.setSequenceVersion(Int(sequenceVersionValue) ?? 0)

        Task {
            await Kovalee.shared.kovaleeManager?.fetchEventSequences()
            Kovalee.shared.kovaleeManager?.setupConversionManager()
            await MainActor.run {
                retrieveValues()
            }
        }

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}
