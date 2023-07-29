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

    var gastosPorMes: [Date: [Gasto]] {
        Dictionary(grouping: gastosFiltrados) { gasto in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: gasto.data)
            return calendar.date(from: components)!
        }
    }

    var mesesOrdenados: [Date] {
        gastosPorMes.keys.sorted()
    }

    let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        formatter.locale = Locale.current
        return formatter
    }()

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar", text: $searchText)
                        .font(.system(size: 18))
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                .padding(.top, 20)

                List {
                    ForEach(mesesOrdenados, id: \.self) { mes in
                        Section(header: Text(monthYearFormatter.string(from: mes)).font(.system(size: 20))) {
                            ForEach(gastosPorMes[mes]!, id: \.id) { gasto in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(gasto.nome)
                                        Text(gasto.tag.joined(separator: ", "))
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    .onTapGesture {
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
                                delete(at: indexSet, from: mes)
                            })
                        }
                    }

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
                .listStyle(GroupedListStyle())
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
            .background(Color(.systemGray6))
        }
    }

    func delete(at offsets: IndexSet, from month: Date) {
        offsets.forEach { offset in
            if let index = carteira.gastos.firstIndex(where: { $0.id == gastosPorMes[month]![offset].id }) {
                carteira.saldo = carteira.saldo + carteira.gastos[index].valor
                carteira.gastos.remove(at: index)
            }
        }
    }
}
