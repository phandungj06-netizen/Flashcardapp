import SwiftUI

struct WordCard: View {
    
    var word: Word
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(word.english)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(word.vietnamese)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(shortType)
                .font(.system(size: 11, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(tagColor)
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
    
    var shortType: String {
        let type = word.posRaw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch type {
        case "noun", "n":
            return "NOUN"
        case "verb", "v":
            return "VERB"
        case "adjective", "adj":
            return "ADJ"
        case "adverb", "adv":
            return "ADV"
        default:
            return type.uppercased()
        }
    }
    
    var tagColor: Color {
        let type = word.posRaw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch type {
        case "noun", "n":
            return .blue
        case "verb", "v":
            return .red
        case "adjective", "adj":
            return .orange
        case "adverb", "adv":
            return .purple
        default:
            return .gray
        }
    }
}
