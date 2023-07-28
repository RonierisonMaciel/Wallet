import SwiftUI

struct TelaNovoGastoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var carteira: Carteira
    @State private var nome = ""
    @State private var valor: Double?
    @State private var tags = [String]()
    @State private var data = Date()
    @State private var showError = false

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
                
                Section {
                    Button(action: {
                        if let valorReal = self.valor {
                            let novoGasto = Gasto(id: UUID(), nome: self.nome, valor: valorReal, data: data, tag: tags)
                            carteira.adicionarGasto(gasto: novoGasto)
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.showError = true
                        }
                    }) {
                        Text("Adicionar Despesa")
                    }
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Erro"), message: Text("Não foi possível adicionar este gasto. Verifique os valores e tente novamente."), dismissButton: .default(Text("Entendi")))
                    }
                    .disabled(nome.isEmpty || valor == nil) // Desativa o botão se algum campo estiver vazio
                }
            }
            .navigationTitle("Nova Despesa")
            .navigationBarItems(leading: Button("Cancelar") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
