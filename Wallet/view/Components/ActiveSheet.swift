import Foundation

enum ActiveSheet: Identifiable {
    case addExpense, editExpense

    var id: Int {
        hashValue
    }
}
