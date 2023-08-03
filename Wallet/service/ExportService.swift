import Foundation

class ExportService {
    enum ExportFormat {
        case csv, json
    }
    
    func exportGastos(gastos: [Gasto], format: ExportFormat) -> URL? {
        switch format {
        case .csv:
            return exportGastosAsCSV(gastos: gastos)
        case .json:
            return exportGastosAsJSON(gastos: gastos)
        }
    }
    
    private func exportGastosAsCSV(gastos: [Gasto]) -> URL? {
        let fileName = "gastos.csv"
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = path.appendingPathComponent(fileName)

        var csvText = "Data,Valor,Descricao\n"
        for gasto in gastos {
            let row = "\(gasto.data),\(gasto.valor),\(gasto.nome)\n"
            csvText.append(contentsOf: row)
        }

        do {
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Falha ao exportar para CSV: \(error)")
            return nil
        }

        return fileURL
    }
    
    private func exportGastosAsJSON(gastos: [Gasto]) -> URL? {
        let fileName = "gastos.json"
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = path.appendingPathComponent(fileName)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        do {
            let jsonData = try encoder.encode(gastos)
            try jsonData.write(to: fileURL)
        } catch {
            print("Falha ao exportar para JSON: \(error)")
            return nil
        }
        
        return fileURL
    }
}
