import SwiftUI

struct TelaGastosView: View {
    @EnvironmentObject private var carteira: Carteira
    @State private var activeSheet: ActiveSheet?
    @State private var searchText = ""
<<<<<<< HEAD
    @State private var gastoSelecionado: Gasto?  // Adicionado
    @State private var gastoSelecionadoIndex: Int?  // Adicionado
=======
    @State private var gastoSelecionado: Gasto?
    @State private var gastoSelecionadoIndex: Int?
>>>>>>> 2ba26ba (Merge remote-tracking branch 'refs/remotes/origin/main')

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
<<<<<<< HEAD
                            Text(gasto.tag.joined(separator: ", "))  // Alterado aqui para exibir tags
=======
                            Text(gasto.tag.joined(separator: ", "))
>>>>>>> 2ba26ba (Merge remote-tracking branch 'refs/remotes/origin/main')
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            self.gastoSelecionado = gasto
                            self.gastoSelecionadoIndex = carteira.gastos.firstIndex(where: { $0.id == gasto.id })
                            activeSheet = .editExpense
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
                activeSheet = .addExpense
            }) {
                Image(systemName: "plus")
            })
            .fullScreenCover(item: $activeSheet) { item in
                switch item {
                case .addExpense:
                    TelaNovoGastoView().environmentObject(carteira)
                case .editExpense:
<<<<<<< HEAD
                    if let index = gastoSelecionadoIndex {
                        EditarGastoView(gastoIndex: index, carteira: carteira)
=======
                    if let gastoParaEditar = gastoSelecionado {
                        EditarGastoView(gasto: Binding(get: { gastoParaEditar }, set: { gastoSelecionado = $0 })).environmentObject(carteira)
>>>>>>> 2ba26ba (Merge remote-tracking branch 'refs/remotes/origin/main')
                    } else {
                        EmptyView()
                    }
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
