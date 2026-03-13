import SwiftUI
import FirebaseCore

@main
struct FlashcardApp: App {
    
    @StateObject var auth = AuthManager()
    @StateObject var manager = FirebaseManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if auth.user != nil {
                MainTabView(manager: manager)
                    .environmentObject(auth)
            } else {
                LoginView()
                    .environmentObject(auth)
            }
        }
    }
}

