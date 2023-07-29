import Foundation

struct Gasto: Identifiable, Codable, Exportable {
    var id = UUID()
    var nome: String
    var valor: Double
    var data: Date
    var tag: [String]
    
    func exportAsCSV() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: data)
        
        let tags = tag.joined(separator: ", ")
        
        return "\(nome),\(valor),\(dateString),\(tags)"
    }
    
    func exportAsTXT() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: data)
        
        let tags = tag.joined(separator: ", ")
        
        return "Nome: \(nome)\nValor: \(valor)\nData: \(dateString)\nTags: \(tags)"
    }
}
