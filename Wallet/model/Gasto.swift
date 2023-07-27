import Foundation

struct Gasto: Identifiable, Codable {
    var id = UUID()
    var nome: String
    var valor: Double
    var data: Date
    var tag: String
}
