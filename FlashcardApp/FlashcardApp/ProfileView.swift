import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var auth: AuthManager
    @State private var showLogoutConfirm = false
    
    var body: some View {
        
        ZStack {
            
            Color(.systemBackground)
                .ignoresSafeArea()
            
            Circle()
                .fill(Color.blue.opacity(0.12))
                .frame(width: 180, height: 180)
                .offset(x: 140, y: -320)
            
            Circle()
                .fill(Color.blue.opacity(0.08))
                .frame(width: 130, height: 130)
                .offset(x: 120, y: -290)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    
                    Text("Tài khoản")
                        .font(.system(size: 30, weight: .bold))
                        .padding(.top, 12)
                    
                    VStack(spacing: 16) {
                        
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 78))
                            .foregroundStyle(.black, Color(.systemGray5))
                        
                        Text("Bạn đã đăng nhập")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(.label))
                        
                        if let email = auth.user?.email, !email.isEmpty {
                            Text(email)
                                .font(.system(size: 15))
                                .foregroundColor(Color(.secondaryLabel))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                    
                    Button {
                        showLogoutConfirm = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 18, weight: .medium))
                            
                            Text("Đăng xuất")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, 18)
                        .frame(height: 60)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .confirmationDialog(
            "Bạn có muốn đăng xuất không?",
            isPresented: $showLogoutConfirm,
            titleVisibility: .visible
        ) {
            Button("Đăng xuất", role: .destructive) {
                auth.signOut()
            }
            
            Button("Hủy", role: .cancel) { }
        }
    }
}
