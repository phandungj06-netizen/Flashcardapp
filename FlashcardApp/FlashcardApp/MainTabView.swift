import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var manager: FirebaseManager
    @State private var selectedTab = 0
    @State private var showAddView = false
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            TabView(selection: $selectedTab) {
                
                // Trang chủ
                HomeView(manager: manager)
                    .tag(0)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Trang chủ")
                    }
                
                // Ôn tập
                ReviewView(manager: manager)
                    .tag(1)
                    .tabItem {
                        Image(systemName: "brain.head.profile")
                        Text("Ôn tập")
                    }
                
                // Biểu đồ
                ChartView(manager: manager)
                    .tag(2)
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text("Biểu đồ")
                    }
                
                // Tôi
                ProfileView()
                    .tag(3)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Tôi")
                    }
            }
            
            // NÚT + CHỈ HIỆN Ở TRANG CHỦ
            if selectedTab == 0 {
                Button {
                    showAddView = true
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 65, height: 65)
                            .foregroundColor(.black)
                            .shadow(radius: 6)
                        
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .offset(y: -55)
                .sheet(isPresented: $showAddView) {
                    AddWordView(manager: manager)
                }
            }
        }
    }
}
