import SwiftUI

struct TelaInicialView: View {
    @ObservedObject var carteira: Carteira

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 20) {
                    Text("Carteira de bolso!")
                        .font(.largeTitle)
                        .padding()

                    Text("Saldo na carteira: R$")
                        .font(.title2)
                        .padding()

                    HStack {
                        VStack {
                            Text("Gasto total")
                            Text("R$")
                        }
                        VStack {
                            Text("Gasto médio")
                            Text("R$")
                        }
                        VStack {
                            Text("Maior gasto")
                            Text("R$")
                        }
                    }

                    LazyHStack(spacing: 20) {
                        NavigationLink(destination: TelaGastosView(carteira: carteira)) {
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

                        NavigationLink(destination: TelaCarteiraView(carteira: carteira)) {
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
                        NavigationLink(destination: TelaCarteiraView(carteira: carteira)) {
                            HStack {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .font(.system(size: 25))
                                Text("Exportar")
                                    .font(.headline)
                            }
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
