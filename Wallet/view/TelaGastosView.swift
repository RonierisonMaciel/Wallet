import SwiftUI

struct TelaGastosView: View {
    @ObservedObject var carteira: Carteira
    @State var novoGastoNome: String = ""
    @State var novoGastoValor: Double = 0.0
    @State var novoGastoTag: String = ""
    
    var body: some View {
        VStack {
            Text("Total de gastos: \(carteira.gastos.reduce(0) { $0 + $1.valor })")
            Text("Saldo Atual: \(carteira.saldo)")
            List(carteira.gastos) { gasto in
                Text("\(gasto.nome) - \(gasto.valor)")
            }
            TextField("Nome da Despesa", text: $novoGastoNome)
            TextField("Valor da Despesa", value: $novoGastoValor, formatter: NumberFormatter())
            TextField("Tag", text: $novoGastoTag)
            Button("Adicionar Despesa") {
                let gasto = Gasto(nome: novoGastoNome, valor: novoGastoValor, data: Date(), tag: novoGastoTag)
                carteira.adicionarGasto(gasto: gasto)
            }
        }
    }
}
