import Foundation

class Carteira: ObservableObject {
    @Published var saldo: Double
    @Published var gastos: [Gasto]
    
    init(saldo: Double, gastos: [Gasto]) {
        self.saldo = saldo
        self.gastos = gastos
    }
    
    func adicionarValor(valor: Double) {
        saldo += valor
    }
    
    func adicionarGasto(gasto: Gasto) {
        // Verifica se o saldo é suficiente antes de adicionar o gasto
        if saldo >= gasto.valor {
            gastos.append(gasto)
            saldo -= gasto.valor
        } else {
            // Ação ou mensagem de erro para saldo insuficiente
            print("Saldo insuficiente para este gasto.")
        }
    }
    
    func limparGastos() {
        gastos.removeAll()
    }
    
    func limparCarteira() {
        saldo = 0.0
        gastos.removeAll()
    }
}
