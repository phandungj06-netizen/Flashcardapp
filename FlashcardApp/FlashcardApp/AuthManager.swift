import FirebaseAuth
import SwiftUI

class AuthManager: ObservableObject {
    
    @Published var user: User?
    @Published var errorMessage: String?
    
    init() {
        user = Auth.auth().currentUser
    }
    
    var isLoggedIn: Bool {
        user != nil
    }
    
    func signIn(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            DispatchQueue.main.async {
                
                if let error = error as NSError? {
                    
                    switch error.code {
                        
                    case AuthErrorCode.userNotFound.rawValue:
                        self.errorMessage = "Tài khoản không tồn tại."
                        
                    case AuthErrorCode.wrongPassword.rawValue:
                        self.errorMessage = "Sai mật khẩu."
                        
                    case AuthErrorCode.invalidEmail.rawValue:
                        self.errorMessage = "Email không hợp lệ."
                        
                    default:
                        self.errorMessage = error.localizedDescription
                    }
                    
                    return
                }
                
                self.user = result?.user
                self.errorMessage = nil
            }
        }
    }
    
    func signUp(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            DispatchQueue.main.async {
                
                if let error = error as NSError? {
                    
                    switch error.code {
                        
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        self.errorMessage = "Email đã tồn tại."
                        
                    case AuthErrorCode.weakPassword.rawValue:
                        self.errorMessage = "Mật khẩu phải ít nhất 6 ký tự."
                        
                    case AuthErrorCode.invalidEmail.rawValue:
                        self.errorMessage = "Email không hợp lệ."
                        
                    default:
                        self.errorMessage = error.localizedDescription
                    }
                    
                    return
                }
                
                self.user = result?.user
                self.errorMessage = nil
            }
        }
    }
    
   
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            self.errorMessage = "Đăng xuất thất bại."
        }
    }
}
