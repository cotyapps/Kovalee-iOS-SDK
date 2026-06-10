#if os(iOS)
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

        @State private var parsingName: String = "Nurturing"

        var body: some View {
            Group {
                if let fileName = currentSequencesFileName {
                    InfoLabel(title: "Loaded file", value: fileName)
                }

                if let sequence = currentEventsSequence {
                    InfoLabel(title: "Current sequence", value: sequence, horizontal: false)
                }

                if isDebugModeOn {
                    LabeledContent("Sequence version") {
                        TextField("0", text: $sequenceVersionValue)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .sequenceVersion)
                    }

                    LabeledContent("Parsing logic") {
                        TextField("0", text: $parsingLogicValue)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .parsingLogic)
                    }

                    Button(action: refreshAction) {
                        Label("Refresh Sequences", systemImage: "arrow.triangle.2.circlepath")
                    }
                    .buttonStyle(.debugPrimary)
                } else {
                    InfoLabel(title: "Sequence version", value: sequenceVersionValue)
                    InfoLabel(title: "Parsing name", value: parsingName)
                    InfoLabel(title: "Parsing logic", value: parsingLogicValue)
                }
            }
            .task {
                retrieveValues()
            }
            .onChange(of: parsingLogicValue) { _ in
                withAnimation {
                    parsingName = mapParsingName()
                }
            }
        }

        private func mapParsingName() -> String {
            switch Int(parsingLogicValue) ?? 0 {
            case 0: return "Nurturing"
            case 1: return "Mature"
            default: return "Nurturing"
            }
        }

        private func retrieveValues() {
            if let logic = Kovalee.shared.kovaleeManager?.parsingLogic() {
                parsingLogicValue = String(logic)
            }
            if let sequence = Kovalee.shared.kovaleeManager?.sequenceVersion() {
                sequenceVersionValue = String(sequence)
            }

            Task { @MainActor in
                currentSequencesFileName = Kovalee.shared.kovaleeManager?.currentSequencesFileName()
                currentEventsSequence = Kovalee.shared.kovaleeManager?.currentEventsSequence()
            }
        }

        private func refreshAction() {
            focusedField = nil
            Task { @MainActor in
                await Kovalee.shared.kovaleeManager?.resetApp(resetAllData: false)
                Kovalee.shared.kovaleeManager?.resetCVManager()

                Kovalee.shared.kovaleeManager?.setParsingLogic(Int(parsingLogicValue) ?? 0)
                Kovalee.shared.kovaleeManager?.setSequenceVersion(Int(sequenceVersionValue) ?? 0)

                await Kovalee.shared.kovaleeManager?.fetchEventsSequence(sequenceVersion: Int(sequenceVersionValue) ?? 0)
                await Kovalee.shared.kovaleeManager?.setupConversionManager(withParsingLogic: Int(parsingLogicValue) ?? 0)

                await Kovalee.shared.kovaleeManager?.resetApp(resetAllData: false)

                retrieveValues()
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
#endif
