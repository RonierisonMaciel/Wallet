import SwiftUI

struct TelaBoasVindasView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var carteira = Carteira()

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                // Adiciona um gradiente de cor
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Text("Bem-vindo à Carteira de Bolso!")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()

                    Text("Seu aplicativo para controle financeiro pessoal.")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding()

                    Button(action: {
                        self.appState.currentScreen = .inicial
                    }) {
                        Text("Começar")
                            .font(.headline)
                            .frame(width: 220, height: 60)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(15)
                    }
                }
                .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
            }
        }
    }
}

