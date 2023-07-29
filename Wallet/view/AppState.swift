import SwiftUI

class AppState: ObservableObject {
    enum Screen {
        case boasVindas
        case inicial
    }
    
    @Published var currentScreen: Screen = .boasVindas
    
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var carteira = Carteira()  // Crie uma instância de Carteira
    
    var body: some View {
        switch appState.currentScreen {
        case .boasVindas:
            TelaBoasVindasView()
        case .inicial:
            NavigationView {
                TelaInicialView()
                    .environmentObject(carteira)  // Passe a instância de Carteira para TelaInicialView
            }
        }
    }
}
