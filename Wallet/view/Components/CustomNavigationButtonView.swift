import SwiftUI
import Foundation

struct CustomButtonView<Destination: View>: View {
    let icon: String
    let text: String
    let color: Color
    let destination: Destination?
    let action: (() -> Void)?

    init(icon: String, text: String, color: Color, destination: Destination? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.text = text
        self.color = color
        self.destination = destination
        self.action = action
    }

    var body: some View {
        if let destination = destination {
            NavigationLink(destination: destination) {
                buttonContent
            }
        } else if let action = action {
            Button(action: action) {
                buttonContent
            }
        }
    }

    private var buttonContent: some View {
        HStack {
            Image(systemName: icon)
                .font(Font.custom("AvenirNext-DemiBold", size: 25))
            Text(text)
                .font(Font.custom("AvenirNext-DemiBold", size: 20))
        }
        .padding()
        .foregroundColor(.white)
        .background(color)
        .cornerRadius(15)
    }
}
