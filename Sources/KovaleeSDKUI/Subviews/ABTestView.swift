#if os(iOS)
    import KovaleeSDK
    import SwiftUI

    @available(iOS 16.0, *)
    struct ABTestView: View {
        enum FocusedField {
            case abValue
        }

        @FocusState private var focusedField: FocusedField?
        @State private var newABValue: String = ""
        @State private var showAlert: Bool = false
        @State private var alertMessage: String = ""

        @AppStorage(AbTestOverride.enabledKey) private var overrideOnLaunch: Bool = false
        @AppStorage(AbTestOverride.valueKey) private var overrideValue: String = ""

        var body: some View {
            TextField("Set AB test Value", text: $newABValue)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .abValue)

            if overrideOnLaunch, !overrideValue.isEmpty {
                Text("Staged for next launch: \(overrideValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Button("Save Override for Next Launch") {
                focusedField = nil
                let requested = newABValue
                guard !requested.isEmpty else {
                    alertMessage = "Enter a value first."
                    showAlert = true
                    return
                }

                overrideValue = requested
                overrideOnLaunch = true
                alertMessage = "Override saved. Restart the app to apply \(requested)."
                showAlert = true
            }
            .buttonStyle(.borderedProminent)
            .alert("AB Test", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
#endif
