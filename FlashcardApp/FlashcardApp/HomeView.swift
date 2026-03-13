import SwiftUI

struct HomeView: View {
    
    @ObservedObject var manager: FirebaseManager
    @State private var selectedWord: Word?
    @State private var editingWord: Word?
    @State private var currentDate = Date()
    
    var body: some View {
        
        ZStack {
            
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                header
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        ForEach(groupedWords.keys.sorted(by: >), id: \.self) { date in
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(formatDate(date))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                ForEach(groupedWords[date] ?? []) { word in
                                    WordCard(word: word)
                                        .onLongPressGesture {
                                            selectedWord = word
                                        }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        
        .sheet(item: $selectedWord) { word in
            actionSheet(word)
        }
        
        .sheet(item: $editingWord) { word in
            EditWordView(word: word, manager: manager)
        }
    }
    
    // MARK: - HEADER
    var header: some View {
        
        let yearInt = Calendar.current.component(.year, from: currentDate)
        let year = String(format: "%d", yearInt)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: currentDate)
        
        return VStack(spacing: 14) {
            
            HStack {
                
                Button {
                    withAnimation(.easeInOut) {
                        changeMonth(by: -1)
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.blue.opacity(0.6))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text(year)
                        .font(.system(size: 22, weight: .bold))
                    
                    Text(month)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut) {
                        changeMonth(by: 1)
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.blue.opacity(0.6))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Button("Hôm nay") {
                    withAnimation(.easeInOut) {
                        currentDate = Date()
                    }
                }
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            Divider()
        }
    }
    
    // MARK: - GROUP WORDS BY DAY
    var groupedWords: [Date: [Word]] {
        let calendar = Calendar.current
        
        let wordsInMonth = manager.words.filter {
            calendar.isDate($0.createdAt,
                            equalTo: currentDate,
                            toGranularity: .month)
        }
        
        return Dictionary(grouping: wordsInMonth) {
            calendar.startOfDay(for: $0.createdAt)
        }
    }
    
    // MARK: - FORMAT DATE
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM EEEE"
        return "\(formatter.string(from: date)) • \(groupedWords[date]?.count ?? 0) từ"
    }
    
    // MARK: - Change Month
    func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month,
                                               value: value,
                                               to: currentDate) {
            currentDate = newDate
        }
    }
    
    // MARK: - ACTION SHEET
    func actionSheet(_ word: Word) -> some View {
        VStack(spacing: 20) {
            
            WordCard(word: word)
            
            Button {
                editingWord = word
                selectedWord = nil
            } label: {
                Label("Sửa", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Button(role: .destructive) {
                manager.deleteWord(word)
                selectedWord = nil
            } label: {
                Label("Xóa", systemImage: "trash")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }
}
