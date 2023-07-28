import Foundation

class Carteira: ObservableObject {
    @Published var saldo: Double {
        didSet {
            saveData()
        }
    }
    
    @Published var gastos: [Gasto] {
        didSet {
            saveData()
        }
    }
    
    init(saldo: Double, gastos: [Gasto]) {
        self.saldo = saldo
        self.gastos = gastos
        loadData()
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
    
    private func saveData() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(gastos) {
            UserDefaults.standard.set(data, forKey: "gastos")
            UserDefaults.standard.set(saldo, forKey: "saldo")
        }
    }
    
    private func loadData() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "gastos"),
           let decodedGastos = try? decoder.decode([Gasto].self, from: data) {
            self.gastos = decodedGastos
        }
        self.saldo = UserDefaults.standard.double(forKey: "saldo")
    }
}
