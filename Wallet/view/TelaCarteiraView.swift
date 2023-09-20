import SwiftUI

struct TelaCarteiraView: View {
    @EnvironmentObject var carteira: Carteira
    @State private var valorEntrada: String = ""
    @State private var showingActionSheet = false
    @State private var showingModal = false
    @State private var showError = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Saldo na Carteira: R$ \(carteira.saldo, specifier: "%.2f")")
                        .font(Font.custom("AvenirNext-DemiBold", size: 25))
                        .foregroundColor(.white)
                        .padding()

                    TextField("Adicionar Valor", text: $valorEntrada)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)

                    CustomActionButtonView(action: {
                        if let valor = Double(valorEntrada) {
                            carteira.adicionarValor(valor: valor)
                            valorEntrada = ""
                        } else {
                            showError = true
                        }
                    }, icon: "plus.circle.fill", text: "Adicionar Valor", color: .blue)
                    .padding(.top, 50)
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Erro"), message: Text("Valor inválido. Por favor, insira um valor válido."), dismissButton: .default(Text("Entendi")))
                    }

                    CustomActionButtonView(action: {
                        self.showingActionSheet = true
                    }, icon: "ellipsis.circle.fill", text: "Opções", color: .orange)
                    .actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(title: Text("Opções"), buttons: [
                            .destructive(Text("Limpar Gastos"), action: {
                                self.carteira.limparGastos()
                            }),
                            .destructive(Text("Limpar Carteira"), action: {
                                self.carteira.limparCarteira()
                            }),
                            .cancel()
                        ])
                    }
                }
                .padding()
                .navigationBarTitle(Text("Carteira"), displayMode: .inline)
            }
        }
    }
}
