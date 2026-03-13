import Foundation

struct Word: Identifiable, Equatable {
    var id: String
    var english: String
    var vietnamese: String
    var posRaw: String
    var createdAt: Date
    var wordType: String
}
