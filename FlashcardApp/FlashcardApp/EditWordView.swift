import SwiftUI

struct EditWordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var word: Word
    @ObservedObject var manager: FirebaseManager
    
    @State private var selectedType: WordType = .noun
    @State private var selectedDate: Date = Date()
    
    enum WordType: CaseIterable {
        case noun
        case verb
        case adjective
        case adverb
        
        var rawValueForDB: String {
            switch self {
            case .noun: return "noun"
            case .verb: return "verb"
            case .adjective: return "adj"
            case .adverb: return "adv"
            }
        }
        
        var displayName: String {
            rawValueForDB
        }
        
        var color: Color {
            switch self {
            case .noun: return .blue
            case .verb: return .red
            case .adjective: return .orange
            case .adverb: return .purple
            }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section(header: Text("Thông tin từ")) {
                    TextField("Tiếng Anh", text: $word.english)
                    TextField("Tiếng Việt", text: $word.vietnamese)
                }
                
                Section(header: Text("Từ loại")) {
                    HStack(spacing: 12) {
                        ForEach(WordType.allCases, id: \.self) { type in
                            
                            Text(type.displayName)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    selectedType == type
                                    ? type.color
                                    : Color.gray.opacity(0.2)
                                )
                                .foregroundColor(
                                    selectedType == type ? .white : .black
                                )
                                .clipShape(Capsule())
                                .onTapGesture {
                                    selectedType = type
                                }
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("Ngày")) {
                    DatePicker(
                        "Chọn ngày",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle("Sửa từ")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Hủy") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cập nhật") {
                        
                        word.posRaw = selectedType.rawValueForDB
                        word.wordType = selectedType.rawValueForDB
                        word.createdAt = selectedDate
                        
                        manager.updateWord(word)
                        dismiss()
                    }
                }
            }
            .onAppear {
                switch word.posRaw {
                case "noun": selectedType = .noun
                case "verb": selectedType = .verb
                case "adj": selectedType = .adjective
                case "adv": selectedType = .adverb
                default: selectedType = .noun
                }
                
                selectedDate = word.createdAt
            }
        }
    }
}
