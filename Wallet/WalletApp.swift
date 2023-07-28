import SwiftUI

@main
struct WalletApp: App {
    @StateObject var carteira = Carteira(saldo: 0.0, gastos: [])

    var body: some Scene {
        WindowGroup {
            TelaInicialView().environmentObject(carteira)
        }
    }
}
