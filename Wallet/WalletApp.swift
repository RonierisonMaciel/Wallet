import SwiftUI

@main
struct WalletApp: App {
    // Criar uma instância de Carteira
    @StateObject var carteira = Carteira(saldo: 0.0, gastos: [])

    var body: some Scene {
        WindowGroup {
            TelaInicialView(carteira: carteira)
        }
    }
}
