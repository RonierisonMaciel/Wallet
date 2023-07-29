import SwiftUI

@main
struct WalletApp: App {
    @StateObject private var carteira = Carteira()

    var body: some Scene {
        WindowGroup {
            TelaBoasVindasView()
                .environmentObject(carteira)
                .environment(\.windowScene, UIApplication.shared.connectedScenes.first as? UIWindowScene)
        }
    }
}
