import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var auth: AuthManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    @State private var showPassword = false
    
    var body: some View {
        
        ZStack {
            
            Color(.systemBackground)
                .ignoresSafeArea()
            
            // Nền trang trí
            Circle()
                .fill(Color.green.opacity(0.22))
                .frame(width: 220, height: 220)
                .offset(x: 150, y: -320)
            
            Circle()
                .fill(Color.green.opacity(0.18))
                .frame(width: 170, height: 170)
                .offset(x: 120, y: -300)
            
            Circle()
                .fill(Color.green.opacity(0.22))
                .frame(width: 180, height: 180)
                .offset(x: 150, y: 360)
            
            Circle()
                .fill(Color.green.opacity(0.18))
                .frame(width: 130, height: 130)
                .offset(x: 110, y: 340)
            
            VStack(spacing: 0) {
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(isLogin ? "Chào mừng trở lại" : "Tạo tài khoản")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(isLogin ? "Đăng nhập để tiếp tục" : "Đăng ký để bắt đầu sử dụng")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("EMAIL")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            
                            TextField("Nhập email", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("MẬT KHẨU")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            
                            Group {
                                if showPassword {
                                    TextField("Nhập mật khẩu", text: $password)
                                } else {
                                    SecureField("Nhập mật khẩu", text: $password)
                                }
                            }
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    
                    Button {
                        
                        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if cleanEmail.isEmpty || cleanPassword.isEmpty {
                            auth.errorMessage = "Vui lòng nhập đầy đủ email và mật khẩu."
                            return
                        }
                        
                        if !isValidEmail(cleanEmail) {
                            auth.errorMessage = "Email không đúng định dạng."
                            return
                        }
                        
                        if isLogin {
                            auth.signIn(email: cleanEmail, password: cleanPassword)
                        } else {
                            auth.signUp(email: cleanEmail, password: cleanPassword)
                        }
                        
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text(isLogin ? "ĐĂNG NHẬP" : "ĐĂNG KÝ")
                                .font(.system(size: 17, weight: .bold))
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .frame(height: 56)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color.green.opacity(0.35), radius: 10, x: 0, y: 6)
                    }
                    .padding(.top, 6)
                    
                    Button(isLogin ? "Chưa có tài khoản? Đăng ký" : "Đã có tài khoản? Đăng nhập") {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isLogin.toggle()
                        }
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                    .padding(.top, 4)
                }
                .padding(.horizontal, 28)
                .padding(.top, 34)
                
                Spacer()
            }
        }
        .alert("Lỗi", isPresented: Binding(
            get: { auth.errorMessage != nil },
            set: { _ in auth.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(auth.errorMessage ?? "")
        }
    }
    
    // MARK: - Validate Email
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            .evaluate(with: email)
    }
}
