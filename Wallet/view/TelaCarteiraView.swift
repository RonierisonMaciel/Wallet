import SwiftUI

struct TelaCarteiraView: View {
    @ObservedObject var carteira: Carteira
    @State var valorAdicionado: Double = 0.0

    var body: some View {
        VStack {
            Text("Saldo Atual: \(carteira.saldo)")
            TextField("Valor a Adicionar", value: $valorAdicionado, formatter: NumberFormatter())
            Button("Adicionar Valor") {
                carteira.adicionarValor(valor: valorAdicionado)
            }
            Button("Limpar Gastos") {
                carteira.limparGastos()
            }
            Button("Limpar Carteira") {
                carteira.limparCarteira()
            }
            Button("Voltar para Gastos") {
                // Navegue de volta para a Tela de Gastos
            }
        }
    }
}
