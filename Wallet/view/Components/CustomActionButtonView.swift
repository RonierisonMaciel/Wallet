import SwiftUI
import Foundation

struct CustomActionButtonView: View {
    var action: () -> Void
    var icon: String
    var text: String
    var color: Color

    var body: some View {
        Button(action: action) { // aqui é onde você precisa usar a ação que passou
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
                Text(text)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(width: 220, height: 60)
            .background(color)
            .cornerRadius(15)
        }
    }
}
