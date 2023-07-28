import SwiftUI
import Combine

struct DecimalField: View {
    @Binding var value: Double?
    @State private var valueStr: String

    let placeholder: String

    var body: some View {
        TextField(placeholder, text: $valueStr)
            .keyboardType(.decimalPad)
            .onReceive(Just(valueStr)) { newValue in
                let filtered = newValue.filter { "0123456789.".contains($0) }
                if filtered != newValue {
                    self.valueStr = filtered
                }
            }
            .onChange(of: valueStr) { value in
                self.value = Double(value)
            }
    }

    init(_ placeholder: String, value: Binding<Double?>) {
        self.placeholder = placeholder
        _value = value
        _valueStr = State(initialValue: String(value.wrappedValue ?? 0.0))
    }
}
