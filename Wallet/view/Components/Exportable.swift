import Foundation

protocol Exportable {
    func exportAsCSV() -> String
    func exportAsTXT() -> String
}
