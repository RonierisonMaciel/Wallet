import SwiftUI

struct TelaInicialView: View {
    @EnvironmentObject var carteira: Carteira
    @Environment(\.windowScene) var windowScene
    let exportService = ExportService()

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 20) {
                    Text("Carteira de bolso!")
                        .font(Font.custom("AvenirNext-Bold", size: 40))
                        .foregroundColor(.white)
                        .padding()

                    Text("Saldo na carteira: R$ \(carteira.saldo, specifier: "%.2f")")
                        .font(Font.custom("AvenirNext-DemiBold", size: 25))
                        .foregroundColor(.white)
                        .padding()

                    HStack {
                        InfoCardView(icon: "arrow.down.circle", value: carteira.gastos.map({ $0.valor }).reduce(0, +), label: "Total")
                        InfoCardView(icon: "arrow.2.circlepath", value: carteira.gastos.isEmpty ? 0 : carteira.gastos.map({ $0.valor }).reduce(0, +) / Double(carteira.gastos.count), label: "Médio")
                        InfoCardView(icon: "arrow.up.circle", value: carteira.gastos.map({ $0.valor }).max() ?? 0, label: "Maior")
                    }
                    .font(.title3)
                    .padding(.horizontal)

                    LazyHStack(spacing: 20) {
                        NavigationLink(destination: TelaGastosView().environmentObject(carteira)) {
                            CustomActionButtonView(action: {}, icon: "creditcard.fill", text: "Gastos", color: .blue)
                        }

                        NavigationLink(destination: TelaCarteiraView().environmentObject(carteira)) {
                            CustomActionButtonView(action: {}, icon: "wallet.pass.fill", text: carteira.saldo > 0 ? "Carteira" : "Adicionar Valor", color: .green)
                        }
                    }
                    .frame(maxWidth: .infinity)

                    if !carteira.gastos.isEmpty {
                        CustomActionButtonView(action: {
                            if let fileURL = self.exportService.exportGastosAsCSV(gastos: self.carteira.gastos) {
                                self.shareFile(url: fileURL)
                            }
                        }, icon: "square.and.arrow.up.fill", text: "Exportar", color: .purple)
                        .padding(.top, 50)
                    }


                    Spacer()
                }
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
    }

    func shareFile(url: URL) {
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        windowScene?.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
}
