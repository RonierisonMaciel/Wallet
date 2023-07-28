import SwiftUI

struct TelaCarteiraView: View {
    @EnvironmentObject var carteira: Carteira
    @State private var valorEntrada: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Adicionar Valor", text: $valorEntrada)
                    .keyboardType(.decimalPad)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Button(action: {
                    if let valor = Double(valorEntrada) {
                        carteira.saldo += valor
                    }
                    valorEntrada = ""
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
                
                Button(action: {
                    carteira.gastos.removeAll()
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Limpar Gastos")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    carteira.saldo = 0.0
                    carteira.gastos.removeAll()
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Limpar Carteira")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                NavigationLink(
                    destination: TelaGastosView().environmentObject(carteira),
                    label: {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Gastos")
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    })
            }
            .padding()
            .navigationTitle("Carteira")
        }
    }
}
