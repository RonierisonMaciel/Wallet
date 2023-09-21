import Foundation
import SwiftUI

enum CarteiraError: Error {
    case saldoInsuficiente
}

class Carteira: ObservableObject {
    @AppStorage("saldo") private(set) var saldo: Double = 0.0
    @AppStorage("saldoOriginal") private(set) var saldoOriginal: Double = 0.0
    private(set) var gastosTotais: Double = 0.0
    @Published var showError: Bool = false
    @Published var gastoSelecionado: Gasto?
    @Published var gastoSelecionadoIndex: Int?
    @Published var errorMessage: String = ""
    @Published private(set) var gastos: [Gasto] {
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
        saldoOriginal += valor
    }
    
    func adicionarGasto(gasto: Gasto) throws {
        if saldo >= gasto.valor {
            gastos.append(gasto)
            saldo -= gasto.valor
            gastosTotais += gasto.valor
        } else {
            throw CarteiraError.saldoInsuficiente
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
        saldo = saldoOriginal
        gastos.removeAll()
    }
    
    func limparCarteira() {
        saldo = 0.0
        saldoOriginal = 0.0
        gastos.removeAll()
        UserDefaults.standard.removeObject(forKey: "saldo")
        UserDefaults.standard.removeObject(forKey: "saldoOriginal")
    }
    
    private func saveData() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(gastos)
            UserDefaults.standard.set(data, forKey: "gastos")
        } catch {
            print("Erro ao salvar gastos: \(error.localizedDescription)")
            self.errorMessage = "Erro ao salvar gastos. Por favor, tente novamente."
            self.showError = true
        }
    }
    
    private func loadData() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "gastos") {
            do {
                let decodedGastos = try decoder.decode([Gasto].self, from: data)
                self.gastos = decodedGastos
            } catch {
                print("Erro ao carregar gastos: \(error.localizedDescription)")
                self.errorMessage = "Erro ao carregar gastos. Por favor, tente novamente."
                self.showError = true
            }
        }
    }
}
