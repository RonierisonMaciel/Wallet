import Foundation
import SwiftUI

class Carteira: ObservableObject {
    @AppStorage("saldo") var saldo: Double = 0.0
    
    @Published var gastos: [Gasto] {
        didSet {
            saveData()
        }
    }
    
    init() {
        self.gastos = []
        loadData()
    }
    
    func adicionarValor(valor: Double) {
        saldo += valor
    }
    
    func adicionarGasto(gasto: Gasto) {
        if saldo >= gasto.valor {
            gastos.append(gasto)
            saldo -= gasto.valor
        } else {
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
