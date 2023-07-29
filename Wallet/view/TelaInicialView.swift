import SwiftUI

struct TelaInicialView: View {
    @EnvironmentObject var carteira: Carteira
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    let exportService = ExportService()
    
    @State private var arquivoParaCompartilhar: URL?
    @State private var isSharing = false
    @State private var isChoosingExportFormat = false
    
    var body: some View {
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
                    CustomNavigationButtonView(destination: TelaGastosView().environmentObject(carteira), icon: "arrow.down", text: "Gastos", color: .blue)
                    CustomNavigationButtonView(destination: TelaCarteiraView().environmentObject(carteira), icon: "arrow.up", text: "Carteira", color: .blue)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                if !carteira.gastos.isEmpty {
                    CustomActionButtonView(action: {
                        self.isChoosingExportFormat = true
                    }, icon: "square.and.arrow.up.fill", text: "Exportar", color: .purple)
                    .padding(.top, 50)
                    .actionSheet(isPresented: $isChoosingExportFormat) {
                        ActionSheet(title: Text("Escolha o formato de exportação"), buttons: [
                            .default(Text("CSV")) {
                                if let fileURL = self.exportService.exportGastos(gastos: self.carteira.gastos, format: .csv) {
                                    self.arquivoParaCompartilhar = fileURL
                                    self.isSharing = true
                                } else {
                                    print("Falha ao criar o arquivo de exportação CSV.")
                                }
                            },
                            .default(Text("JSON")) {
                                if let fileURL = self.exportService.exportGastos(gastos: self.carteira.gastos, format: .json) {
                                    self.arquivoParaCompartilhar = fileURL
                                    self.isSharing = true
                                } else {
                                    print("Falha ao criar o arquivo de exportação JSON.")
                                }
                            },
                            .cancel()
                        ])
                    }
                    .sheet(isPresented: $isSharing, onDismiss: {
                        arquivoParaCompartilhar = nil
                    }) {
                        if let fileURL = arquivoParaCompartilhar {
                            ActivityViewController(activityItems: [fileURL])
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

struct CustomNavigationButtonView<Content: View>: View {
    let destination: Content
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(text)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(color)
            .cornerRadius(40)
            .font(.title2)
        }
    }
}
