import SwiftUI
import Charts

struct ChartItem: Identifiable {
    let id = UUID()
    let title: String
    let value: Int
    let color: Color
}

struct ChartView: View {
    
    @ObservedObject var manager: FirebaseManager
    
    func normalizedType(for word: Word) -> String {
        let raw = word.posRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        let fallback = word.wordType.trimmingCharacters(in: .whitespacesAndNewlines)
        let type = (raw.isEmpty ? fallback : raw).lowercased()
        
        switch type {
        case "noun":
            return "noun"
        case "verb":
            return "verb"
        case "adj", "adjective":
            return "adj"
        case "adv", "adverb":
            return "adv"
        default:
            return ""
        }
    }
    
    var nounCount: Int {
        manager.words.filter { normalizedType(for: $0) == "noun" }.count
    }
    
    var verbCount: Int {
        manager.words.filter { normalizedType(for: $0) == "verb" }.count
    }
    
    var adjectiveCount: Int {
        manager.words.filter { normalizedType(for: $0) == "adj" }.count
    }
    
    var adverbCount: Int {
        manager.words.filter { normalizedType(for: $0) == "adv" }.count
    }
    
    var totalCount: Int {
        nounCount + verbCount + adjectiveCount + adverbCount
    }
    
    var chartData: [ChartItem] {
        [
            ChartItem(title: "noun", value: nounCount, color: .blue),
            ChartItem(title: "verb", value: verbCount, color: .red),
            ChartItem(title: "adj", value: adjectiveCount, color: .orange),
            ChartItem(title: "adv", value: adverbCount, color: .purple)
        ]
    }
    
    func percentText(for value: Int) -> String {
        guard totalCount > 0 else { return "0%" }
        let percent = Double(value) / Double(totalCount) * 100
        return "\(Int(percent.rounded()))%"
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Biểu đồ từ loại")
                        .font(.system(size: 30, weight: .bold))
                        .padding(.top, 10)
                    
                    if totalCount == 0 {
                        VStack(spacing: 12) {
                            Image(systemName: "chart.pie.fill")
                                .font(.system(size: 52))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("Chưa có dữ liệu")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 90)
                    } else {
                        
                        VStack(spacing: 18) {
                            Chart {
                                ForEach(chartData.filter { $0.value > 0 }) { item in
                                    SectorMark(
                                        angle: .value(item.title, item.value),
                                        innerRadius: .ratio(0),
                                        angularInset: 2
                                    )
                                    .foregroundStyle(item.color)
                                    .annotation(position: .overlay) {
                                        Text(percentText(for: item.value))
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .frame(height: 290)
                            .chartLegend(.hidden)
                            
                            Text("Tổng \(totalCount) từ")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black.opacity(0.8))
                        }
                        .padding(18)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 14),
                                GridItem(.flexible(), spacing: 14)
                            ],
                            spacing: 14
                        ) {
                            statCard(item: chartData[0])
                            statCard(item: chartData[1])
                            statCard(item: chartData[2])
                            statCard(item: chartData[3])
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
        }
    }
    
    func statCard(item: ChartItem) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            
            HStack(spacing: 8) {
                Circle()
                    .fill(item.color)
                    .frame(width: 10, height: 10)
                
                Text(item.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
            }
            
            HStack(alignment: .bottom) {
                Text("\(item.value)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(percentText(for: item.value))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(item.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(item.color.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(item.color.opacity(0.22), lineWidth: 1.2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
