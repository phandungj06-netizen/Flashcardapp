# Flashcard App

Ứng dụng học từ vựng tiếng Anh trên iOS, được phát triển bằng SwiftUI và sử dụng Firebase để xác thực người dùng và lưu trữ dữ liệu.

## Giới thiệu

Flashcard App là ứng dụng hỗ trợ người dùng học từ vựng tiếng Anh theo cách trực quan và dễ sử dụng.  
Ứng dụng cho phép thêm, sửa, xóa từ vựng, ôn tập theo nhiều hình thức và xem biểu đồ thống kê từ loại.

## Chức năng chính

- Đăng ký / đăng nhập tài khoản bằng Firebase Authentication
- Thêm từ vựng mới
- Chỉnh sửa từ vựng
- Xóa từ vựng
- Lưu ngày tạo từ
- Hiển thị danh sách từ vựng theo ngày / tháng
- Ôn tập theo 2 chế độ:
  - Nhập tay
  - Trắc nghiệm
- Biểu đồ thống kê theo từ loại:
  - noun
  - verb
  - adj
  - adv
- Đồng bộ dữ liệu realtime với Firebase Firestore

## Công nghệ sử dụng

- Swift
- SwiftUI
- Firebase Authentication
- Firebase Firestore
- Charts Framework
- Xcode

## Cấu trúc project

```text
FlashcardApp
│
├── FlashcardApp.swift
├── MainTabView.swift
├── LoginView.swift
├── HomeView.swift
├── AddWordView.swift
├── EditWordView.swift
├── ReviewView.swift
├── ChartView.swift
├── ProfileView.swift
├── WordCard.swift
├── Word.swift
├── FirebaseManager.swift
├── AuthManager.swift
└── GoogleService-Info.plist

Giao diện chính

Ứng dụng gồm các màn hình chính:
	•	Đăng nhập / đăng ký
	•	Trang chủ
	•	Ôn tập
	•	Biểu đồ
	•	Tài khoản

Yêu cầu hệ thống
	•	macOS
	•	Xcode 15 trở lên
	•	iOS 16 trở lên
	•	Swift 5+
	•	Tài khoản Firebase

Hướng dẫn cài đặt

1. Clone project

https://github.com/phandungj06-netizen/Flashcardapp.git

2. Mở project bằng Xcode

Mở file project trong Xcode.

3. Cài đặt Firebase
	•	Tạo project trên Firebase Console￼
	•	Bật:
	•	Authentication
	•	Firestore Database
	•	Tải file GoogleService-Info.plist
	•	Kéo file này vào project Xcode

4. Cài package Firebase

Trong Xcode:
	•	Chọn File
	•	Chọn Add Package Dependencies
	•	Thêm Firebase iOS SDK

Các package cần dùng:
	•	FirebaseAuth
	•	FirebaseFirestore
	•	FirebaseCore

5. Chạy project
	•	Chọn simulator hoặc iPhone thật
	•	Nhấn Run

Cấu trúc dữ liệu Firestore

Collection: words

Tài khoản đăng nhập

Người dùng có thể:
	•	Đăng ký tài khoản mới
	•	Đăng nhập bằng email và mật khẩu

Chức năng ôn tập

1. Nhập tay
	•	Ứng dụng hiển thị nghĩa tiếng Việt
	•	Người dùng nhập từ tiếng Anh
	•	Hệ thống kiểm tra đúng / sai

2. Trắc nghiệm
	•	Ứng dụng đưa ra 4 đáp án
	•	Người dùng chọn đáp án đúng
	•	Hệ thống hiển thị kết quả

Chức năng biểu đồ

Biểu đồ hình tròn hiển thị số lượng từ theo từng loại từ:
	•	noun
	•	verb
	•	adj
	•	adv

Điểm nổi bật
	•	Giao diện hiện đại, dễ sử dụng
	•	Dữ liệu đồng bộ realtime
	•	Hỗ trợ học từ vựng theo nhiều cách
	•	Có thống kê trực quan bằng biểu đồ

Hướng phát triển
	•	Thêm tìm kiếm từ vựng
	•	Thêm đánh dấu từ yêu thích
	•	Thêm nhắc nhở học từ mỗi ngày
	•	Thêm phát âm
	•	Thêm phân loại theo chủ đề
	•	Hỗ trợ dark mode hoàn chỉnh hơn

Tác giả
	•	Họ và tên: Phan Văn Dũng
	•	MSV: 2924107566
	•	Lớp: TH29.07
	•	Môn học: Điện toán di động

Link GitHub

https://github.com/phandungj06-netizen/Flashcardapp.git

