import SwiftUI

struct CustomNavigationButtonView<Destination: View>: View {
    let destination: Destination
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        NavigationLink(destination: destination) {
            CustomButtonView(icon: icon, text: text, color: color)
        }
    }
}
