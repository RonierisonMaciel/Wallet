import SwiftUI

struct TelaGastosView: View {
    @EnvironmentObject private var carteira: Carteira
    @State private var isSheetPresented = false
    @State private var isEditingExpense = false
    @State private var searchText = ""
    @State private var gastoSelecionado: Gasto?
    @State private var gastoSelecionadoIndex: Int?

    var total: Double {
        carteira.gastos.reduce(0) { $0 + $1.valor }
    }

    var saldoAtual: Double {
        return carteira.saldo
    }

    var gastosFiltrados: [Gasto] {
        if searchText.isEmpty {
            return carteira.gastos
        } else {
            return carteira.gastos.filter { gasto in
                return gasto.nome.contains(searchText) ||
                       gasto.tag.contains(where: { $0.contains(searchText) })
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading)
                TextField("Buscar", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
            List {
                ForEach(gastosFiltrados) { gasto in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(gasto.nome)
                            Text(gasto.tag.joined(separator: ", "))
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            print("Tocou no gasto")  // Ponto de depuração
                            self.gastoSelecionado = gasto
                            self.gastoSelecionadoIndex = carteira.gastos.firstIndex(where: { $0.id == gasto.id })
                            self.isEditingExpense = true
                            self.isSheetPresented = true
                        }
                        Spacer()
                        Text("R$ \(gasto.valor, specifier: "%.2f")")
                    }
                }
                .onDelete(perform: { indexSet in
                    delete(at: indexSet)
                })

                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text("R$ \(total, specifier: "%.2f")")
                        .font(.headline)
                }

                HStack {
                    Text("Saldo Atual")
                        .font(.headline)
                    Spacer()
                    Text("R$ \(saldoAtual, specifier: "%.2f")")
                        .font(.headline)
                }
            }
            .navigationTitle("Gastos")
            .navigationBarItems(trailing: Button(action: {
                self.isEditingExpense = false
                self.isSheetPresented = true
            }) {
                Image(systemName: "plus")
            })
            .fullScreenCover(isPresented: $isSheetPresented) {
                if self.isEditingExpense, let gastoParaEditar = self.gastoSelecionado, let gastoIndex = self.gastoSelecionadoIndex {
                    EditarGastoView(gastoParaEditar: gastoParaEditar, index: gastoIndex).environmentObject(self.carteira)
                } else {
                    TelaNovoGastoView().environmentObject(self.carteira)
                }
            }
        }
    }

    func delete(at offsets: IndexSet) {
        offsets.forEach { offset in
            if let index = carteira.gastos.firstIndex(where: { $0.id == gastosFiltrados[offset].id }) {
                carteira.saldo = carteira.saldo + carteira.gastos[index].valor
                carteira.gastos.remove(at: index)
            }
        }
    }
}
