import SwiftUI
import Foundation

struct CustomActionButtonView: View {
    let action: () -> Void
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        Button(action: action) {
            CustomActionButtonView(action: {
                // Coloque aqui a ação que você quer que aconteça quando o botão é pressionado.
                print("Botão pressionado!")
            }, icon: "square.and.arrow.up.fill", text: "Exportar", color: .purple)
            .padding(.top, 50)
        }
    }
}
