import SwiftUI

struct TelaGastosView: View {
    @EnvironmentObject var carteira: Carteira
    @State private var activeSheet: ActiveSheet?
    @State private var searchText = ""

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
                .padding(.top, 20)  // Add some space at the top
            List {
                ForEach(gastosFiltrados) { gasto in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(gasto.nome)
                            Text(gasto.tag)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            if let index = carteira.gastos.firstIndex(where: { $0.id == gasto.id }) {
                                activeSheet = .editExpense
                            }
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
                    TelaNovoGastoView(carteira: carteira)
                case .editExpense:
                    if let index = carteira.gastos.firstIndex(where: { $0.id == gasto.id }) {
                        EditarGastoView(gasto: $carteira.gastos[index])
                    }
                default:
                    EmptyView()
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
