import SwiftUI

struct EditarGastoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var carteira: Carteira
    @Binding var gasto: Gasto
    @State var nome: String
    @State var valor: String
    @State private var tags = [String]()
    @State var data: Date

    init(gasto: Binding<Gasto>) {
        _gasto = gasto
        _nome = State(initialValue: gasto.wrappedValue.nome)
        _valor = State(initialValue: String(format: "%.2f", gasto.wrappedValue.valor))
        _tags = State(initialValue: gasto.wrappedValue.tag)
        _data = State(initialValue: gasto.wrappedValue.data)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Nome", text: $nome)
                TextField("Valor", text: $valor)
                
                DatePicker("Data", selection: $data, displayedComponents: .date)
                
                TextField("Tags (separadas por vírgulas)", text: Binding(
                    get: { self.tags.joined(separator: ", ") },
                    set: { self.tags = $0.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) } }
                ))
            }
            .navigationTitle("Editar Gasto")
            .navigationBarItems(trailing: Button("Salvar") {
                let novoValor = Double(valor.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                let valorDiferenca = novoValor - gasto.valor
                carteira.saldo -= valorDiferenca  // Subtract the amount difference from the wallet

                // Update the properties of gasto directly
                gasto.nome = nome
                gasto.valor = novoValor
                gasto.data = data
                gasto.tag = tags

                // Dismiss the view
                presentationMode.wrappedValue.dismiss()
            })
            .padding(.top, 20)
        }
    }
}
