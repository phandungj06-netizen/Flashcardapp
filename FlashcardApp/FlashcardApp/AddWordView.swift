import SwiftUI

struct AddWordView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: FirebaseManager
    
    @State private var selectedType: WordType = .noun
    @State private var english = ""
    @State private var vietnamese = ""
    @State private var selectedDate = Date()
    
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
            switch self {
            case .noun: return "noun"
            case .verb: return "verb"
            case .adjective: return "adj"
            case .adverb: return "adv"
            }
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
                    TextField("Tiếng Anh", text: $english)
                    TextField("Tiếng Việt", text: $vietnamese)
                }
                
                Section(header: Text("Ngày")) {
                    DatePicker(
                        "Chọn ngày",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.compact)
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
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Thêm từ")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Huỷ") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Lưu") {
                        
                        guard !english.isEmpty,
                              !vietnamese.isEmpty else { return }
                        
                        manager.addWord(
                            english: english,
                            vietnamese: vietnamese,
                            posRaw: selectedType.rawValueForDB,
                            wordType: selectedType.rawValueForDB,
                            createdAt: selectedDate
                        )
                        
                        dismiss()
                    }
                }
            }
        }
    }
}
