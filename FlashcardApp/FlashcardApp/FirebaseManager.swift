import Foundation
import FirebaseFirestore

class FirebaseManager: ObservableObject {
    
    @Published var words: [Word] = []
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        fetchWords()
    }
    
    deinit {
        listener?.remove()
    }
    
    // MARK: - Fetch
    func fetchWords() {
        
        listener = db.collection("words")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                
                if let error = error {
                    print("Firestore fetch error:", error.localizedDescription)
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                self.words = documents.map { doc in
                    
                    let data = doc.data()
                    
                    return Word(
                        id: doc.documentID,
                        english: data["english"] as? String ?? "",
                        vietnamese: data["vietnamese"] as? String ?? "",
                        posRaw: data["posRaw"] as? String ?? "",
                        createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                        wordType: data["wordType"] as? String ?? ""
                    )
                }
            }
    }
    
    // MARK: - Add
    func addWord(english: String,
                 vietnamese: String,
                 posRaw: String,
                 wordType: String,
                 createdAt: Date = Date()) {
        
        db.collection("words").addDocument(data: [
            "english": english,
            "vietnamese": vietnamese,
            "posRaw": posRaw,
            "wordType": wordType,
            "createdAt": Timestamp(date: createdAt)
        ])
    }
    
    // MARK: - Delete
    func deleteWord(_ word: Word) {
        db.collection("words")
            .document(word.id)
            .delete()
    }
    
    // MARK: - Update
    func updateWord(_ word: Word) {
        db.collection("words")
            .document(word.id)
            .updateData([
                "english": word.english,
                "vietnamese": word.vietnamese,
                "posRaw": word.posRaw,
                "wordType": word.wordType,
                "createdAt": Timestamp(date: word.createdAt)
            ])
    }
}
