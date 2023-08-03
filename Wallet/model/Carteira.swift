import Foundation
import SwiftUI

class Carteira: ObservableObject {
    @AppStorage("saldo") var saldo: Double = 0.0
    private var saldoOriginal: Double?
    @Published var gastos: [Gasto] {
        didSet {
            saveData()
        }
    }

    init() {
        self.gastos = []
        loadData()
        saldoOriginal = saldo
        print("Carteira inicializada com sucesso")
    }
    
    func adicionarValor(valor: Double) {
        if saldoOriginal == nil {
            saldoOriginal = valor
        }
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
        if let saldoInicial = saldoOriginal {
            saldo = saldoInicial
        }
    }
    
    func limparCarteira() {
        saldo = 0.0
        saldoOriginal = nil
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
