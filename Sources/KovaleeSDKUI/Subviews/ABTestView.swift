import KovaleeSDK
import SwiftUI

@available(iOS 16.0, *)
struct ABTestView: View {
    enum FocusedField {
        case abValue
    }

    @FocusState private var focusedField: FocusedField?
    @State private var newABValue: String = ""

    var body: some View {
        TextField("Set AB test Value", text: $newABValue)
            .keyboardType(.numberPad)
            .focused($focusedField, equals: .abValue)

        Button("Update Value") {
            focusedField = nil
            Kovalee.shared.kovaleeManager?.setAbTestValue(newABValue)
            Kovalee.shared.kovaleeManager?.resetApp()
        }
        .buttonStyle(.borderedProminent)
    }
}
