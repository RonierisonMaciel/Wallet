import SwiftUI

struct EditarGastoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var carteira: Carteira

    @State private var nome: String
    @State private var valor: String
    @State private var tags = [String]()
    @State private var data: Date
    var index: Int

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
            .onAppear(perform: loadData)
            .navigationTitle("Editar Gasto")
            .navigationBarItems(trailing: Button("Salvar") {
                updateData()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    init(gastoParaEditar: Gasto, index: Int) {
        _nome = State(initialValue: gastoParaEditar.nome)
        _valor = State(initialValue: String(format: "%.2f", gastoParaEditar.valor))
        _tags = State(initialValue: gastoParaEditar.tag)
        _data = State(initialValue: gastoParaEditar.data)
        self.index = index
    }
    
    func loadData() {
        nome = carteira.gastos[index].nome
        valor = String(format: "%.2f", carteira.gastos[index].valor)
        tags = carteira.gastos[index].tag
        data = carteira.gastos[index].data
    }

    func updateData() {
        let novoValor = Double(valor.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let valorDiferenca = novoValor - carteira.gastos[index].valor
        carteira.saldo -= valorDiferenca

        carteira.gastos[index].nome = nome
        carteira.gastos[index].valor = novoValor
        carteira.gastos[index].data = data
        carteira.gastos[index].tag = tags
    }
}
