import Foundation

class ExportService {
    func exportGastosAsCSV(gastos: [Gasto]) -> URL? {
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
}

