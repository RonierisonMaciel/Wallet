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
        gastos.append(gasto)
        saldo -= gasto.valor
    }
    
    func limparGastos() {
        gastos.removeAll()
    }
    
    func limparCarteira() {
        saldo = 0.0
        gastos.removeAll()
    }
}
