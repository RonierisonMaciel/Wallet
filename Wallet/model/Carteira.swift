import Foundation
import SwiftUI

class Carteira: ObservableObject {
    @AppStorage("saldo") var saldo: Double = 0.0
    @AppStorage("saldoOriginal") var saldoOriginal: Double = 0.0
    var gastosTotais: Double = 0.0
    @Published var gastos: [Gasto] {
        didSet {
            saveData()
        }
    }
    
    init() {
        self.gastos = []
        loadData()
        print("Carteira inicializada com sucesso")
    }
    
    func adicionarValor(valor: Double) {
        saldo += valor
        saldoOriginal += valor
    }
    
    func adicionarGasto(gasto: Gasto) {
        if saldo >= gasto.valor {
            gastos.append(gasto)
            saldo -= gasto.valor
            gastosTotais += gasto.valor
        } else {
            print("Saldo insuficiente para este gasto.")
        }
    }
    
    func removerGasto(at offsets: IndexSet) {
        for index in offsets {
            let gasto = gastos[index]
            saldo += gasto.valor
            gastosTotais -= gasto.valor
        }
        gastos.remove(atOffsets: offsets)
    }
    
    func editarGasto(_ gasto: Gasto, with novoGasto: Gasto) {
        if let index = gastos.firstIndex(where: { $0.id == gasto.id }) {
            let diferenca = novoGasto.valor - gasto.valor
            saldo -= diferenca
            saldoOriginal -= diferenca
            gastos[index] = novoGasto
        }
    }
    
    func limparGastos() {
        let totalGastos = gastos.reduce(0) { $0 + $1.valor }
        
        if totalGastos > 0 {
            saldo -= saldoOriginal
            gastos.removeAll()
            print("Gastos limpos")
        } else if totalGastos < saldo {
                    print("totalGastos < saldo")
            }
    }

    func limparCarteira() {
        saldo = 0.0
        saldoOriginal = 0.0
        gastos.removeAll()
        UserDefaults.standard.removeObject(forKey: "saldo")
        UserDefaults.standard.removeObject(forKey: "saldoOriginal")
        print("Carteira limpa")
    }
    
    private func saveData() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(gastos) {
            UserDefaults.standard.set(data, forKey: "gastos")
        }
    }
    
    private func loadData() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "gastos"),
           let decodedGastos = try? decoder.decode([Gasto].self, from: data) {
            self.gastos = decodedGastos
        }
    }
}
