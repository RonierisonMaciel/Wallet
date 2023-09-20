import SwiftUI

struct TelaNovoGastoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var carteira: Carteira
    @State private var nome = ""
    @State private var valor: Double?
    @State private var tags = [String]()
    @State private var data = Date()
    @State private var showError = false
    @State private var errorMessage: String = ""

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
                            do {
                                try carteira.adicionarGasto(gasto: novoGasto)
                                self.presentationMode.wrappedValue.dismiss()
                            } catch CarteiraError.saldoInsuficiente {
                                self.errorMessage = "Você não tem saldo suficiente para fazer esse gasto."
                                self.showError = true
                            } catch {
                                self.errorMessage = "Ocorreu um erro desconhecido."
                                self.showError = true
                            }
                        } else {
                            self.errorMessage = "Não foi possível adicionar este gasto. Verifique os valores e tente novamente."
                            self.showError = true
                        }
                    }) {
                        Text("Adicionar Despesa")
                    }
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Erro"), message: Text(errorMessage), dismissButton: .default(Text("Entendi")))
                    }
                    .disabled(nome.isEmpty || valor == nil)
                }
            }
            .navigationTitle("Nova Despesa")
            .navigationBarItems(leading: Button("Cancelar") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
