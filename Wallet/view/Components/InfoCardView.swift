import SwiftUI

struct InfoCardView: View {
    let icon: String
    let value: Double
    let label: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            Text(String(format: "%.2f", value))
                .font(Font.custom("AvenirNext-DemiBold", size: 20))
                .foregroundColor(.white)
            Text(label)
                .font(Font.custom("AvenirNext-Regular", size: 18))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
    }
}

struct CustomButtonView: View {
    let icon: String
    let text: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                Text(text)
                    .font(Font.custom("AvenirNext-DemiBold", size: 20))
                    .foregroundColor(.white)
            }
            .padding()
            .background(color)
            .cornerRadius(15)
        }
    }
}
