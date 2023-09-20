import SwiftUI

struct EditarGastoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var carteira: Carteira

    @State private var nome: String
    @State private var valor: Double?
    @State private var tags = [String]()
    @State private var data: Date
    @State private var showError = false
    @State private var errorMessage: String = ""
    var index: Int

    var body: some View {
        NavigationView {
            Form {
                TextField("Nome", text: $nome)
                DecimalField("Valor", value: $valor)
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
                if !showError {
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .alert(isPresented: $showError) {
                Alert(title: Text("Erro"), message: Text(errorMessage), dismissButton: .default(Text("Entendi")))
            }
        }
    }
    
    init(gastoParaEditar: Gasto, index: Int) {
        _nome = State(initialValue: gastoParaEditar.nome)
        _valor = State(initialValue: gastoParaEditar.valor)
        _tags = State(initialValue: gastoParaEditar.tag)
        _data = State(initialValue: gastoParaEditar.data)
        self.index = index
    }
    
    func loadData() {
        nome = carteira.gastos[index].nome
        valor = carteira.gastos[index].valor
        tags = carteira.gastos[index].tag
        data = carteira.gastos[index].data
    }

    func updateData() {
        let gastoAtual = carteira.gastos[index]
        let novoGasto = Gasto(id: gastoAtual.id, nome: nome, valor: valor ?? 0.0, data: data, tag: tags)
        
        let diferenca = novoGasto.valor - gastoAtual.valor
        if carteira.saldo - diferenca >= 0 {
            carteira.editarGasto(gastoAtual, with: novoGasto)
        } else {
            errorMessage = "Saldo insuficiente para editar este gasto."
            showError = true
        }
    }
}
