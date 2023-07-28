import SwiftUI

struct TelaInicialView: View {
    @EnvironmentObject var carteira: Carteira

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 20) {
                    Text("Carteira de bolso!")
                        .font(.largeTitle)
                        .padding()

                    Text("Saldo na carteira: R$ \(carteira.saldo, specifier: "%.2f")")
                        .font(.title2)
                        .padding()

                    HStack {
                        VStack {
                            Text("Gasto total")
                            Text("R$ \(carteira.gastos.map({ $0.valor }).reduce(0, +), specifier: "%.2f")")
                        }
                        VStack {
                            Text("Gasto médio")
                            Text("R$ \(carteira.gastos.isEmpty ? 0 : carteira.gastos.map({ $0.valor }).reduce(0, +) / Double(carteira.gastos.count), specifier: "%.2f")")
                        }
                        VStack {
                            Text("Maior gasto")
                            Text("R$ \(carteira.gastos.map({ $0.valor }).max() ?? 0, specifier: "%.2f")")
                        }
                    }

                    LazyHStack(spacing: 20) {
                        NavigationLink(destination: TelaGastosView().environmentObject(carteira)) {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .font(.system(size: 25))
                                Text("Gastos")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }

                        NavigationLink(destination: TelaCarteiraView().environmentObject(carteira)) {
                            HStack {
                                Image(systemName: "wallet.pass.fill")
                                    .font(.system(size: 25))
                                Text("Adicionar Valor")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }.frame(maxWidth: .infinity)

                    if !carteira.gastos.isEmpty {
                        NavigationLink(destination: TelaCarteiraView().environmentObject(carteira)) {
                            HStack {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .font(.system(size: 25))
                                Text("Exportar")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.top, 50)
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }
}
