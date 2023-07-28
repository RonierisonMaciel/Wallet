import SwiftUI

struct TelaCarteiraView: View {
    @EnvironmentObject var carteira: Carteira
    @State private var valorEntrada: String = ""
    @State private var showingActionSheet = false
    @State private var showingModal = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Saldo na Carteira: R$ \(carteira.saldo, specifier: "%.2f")")
                    .font(.title2)
                    .padding()

                if carteira.saldo <= 0 {
                    TextField("Adicionar Valor", text: $valorEntrada)
                        .keyboardType(.decimalPad)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                Button(action: {
                    if carteira.saldo > 0 {
                        self.showingModal = true
                    } else {
                        if let valor = Double(valorEntrada) {
                            carteira.saldo += valor
                        }
                        valorEntrada = ""
                    }
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Adicionar Valor")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .sheet(isPresented: $showingModal) {
                    VStack(spacing: 20) {
                        Text("Acrescentar Valor")
                            .font(.system(size: 25))
                        TextField("Valor", text: $valorEntrada)
                            .keyboardType(.decimalPad)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        Button(action: {
                            if let valor = Double(self.valorEntrada) {
                                self.carteira.saldo += valor
                            }
                            self.valorEntrada = ""
                            self.showingModal = false
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Acrescentar")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }

                Button(action: {
                    self.showingActionSheet = true
                }) {
                    HStack {
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Opções")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Opções"), buttons: [
                        .destructive(Text("Limpar Gastos"), action: {
                            self.carteira.gastos.removeAll()
                        }),
                        .destructive(Text("Limpar Carteira"), action: {
                            self.carteira.saldo = 0.0
                            self.carteira.gastos.removeAll()
                        }),
                        .cancel()
                    ])
                }
            }
            .padding()
            .navigationTitle("Carteira")
        }
    }
}
