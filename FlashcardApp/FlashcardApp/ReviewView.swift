import SwiftUI

enum ReviewMode {
    case typing
    case multipleChoice
}

struct ReviewView: View {
    
    @ObservedObject var manager: FirebaseManager
    
    @State private var currentWord: Word?
    @State private var answers: [String] = []
    @State private var selectedAnswer: String?
    @State private var showResult = false
    
    @State private var reviewMode: ReviewMode = .typing
    @State private var userInput = ""
    
    var body: some View {
        
        ZStack {
            
            Color(.systemBackground)
                .ignoresSafeArea()
            
            Circle()
                .fill(Color.blue.opacity(0.12))
                .frame(width: 180, height: 180)
                .offset(x: 145, y: -320)
            
            Circle()
                .fill(Color.blue.opacity(0.08))
                .frame(width: 130, height: 130)
                .offset(x: 115, y: -270)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 26) {
                    
                    header
                    
                    if let word = currentWord {
                        questionCard(word: word)
                            .padding(.top, 18)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 46))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("Chưa có từ nào để ôn tập")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 120)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            generateQuestion()
        }
    }
}

// MARK: - HEADER

extension ReviewView {
    
    var header: some View {
        HStack(alignment: .center) {
            
            Text("Ôn tập")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            modeSwitch
        }
    }
    
    var modeSwitch: some View {
        HStack(spacing: 0) {
            
            Button {
                reviewMode = .typing
                generateQuestion()
            } label: {
                Text("Nhập tay")
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .frame(width: 92, height: 40)
                    .background(reviewMode == .typing ? Color.blue : Color.clear)
                    .foregroundColor(reviewMode == .typing ? .white : .blue)
            }
            
            Button {
                reviewMode = .multipleChoice
                generateQuestion()
            } label: {
                Text("Trắc nghiệm")
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .frame(width: 112, height: 40)
                    .background(reviewMode == .multipleChoice ? Color.blue : Color.clear)
                    .foregroundColor(reviewMode == .multipleChoice ? .white : .blue)
            }
        }
        .background(Color.blue.opacity(0.14))
        .clipShape(Capsule())
    }
}

// MARK: - QUESTION CARD

extension ReviewView {
    
    func questionCard(word: Word) -> some View {
        
        VStack(spacing: 24) {
            
            Text("Nghĩa của từ")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            Text(word.vietnamese)
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.vertical, 16)
                .padding(.horizontal, 28)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.28),
                                    Color.blue.opacity(0.14)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            
            if reviewMode == .typing {
                typingView(word: word)
            } else {
                multipleChoiceView(word: word)
            }
            
            if showResult {
                Button("Câu tiếp theo") {
                    generateQuestion()
                }
                .buttonStyle(Primary3DButton())
                .padding(.top, 4)
            }
        }
        .padding(26)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 6)
        )
    }
}

// MARK: - TYPING MODE

extension ReviewView {
    
    func typingView(word: Word) -> some View {
        VStack(spacing: 18) {
            
            HStack(spacing: 12) {
                Image(systemName: "pencil")
                    .foregroundColor(.gray)
                
                TextField("Nhập từ tiếng Anh...", text: $userInput)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .disabled(showResult)
                    .allowsHitTesting(!showResult)
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(showResult ? Color.blue.opacity(0.18) : Color.clear, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .opacity(showResult ? 0.96 : 1)
            
            if !showResult {
                Button("Kiểm tra") {
                    showResult = true
                }
                .buttonStyle(Primary3DButton())
            }
            
            if showResult {
                let isCorrect = checkAnswer(user: userInput, correct: word.english)
                
                HStack(spacing: 10) {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(.white)
                    
                    Text(isCorrect ? "Chính xác!" : "Đáp án đúng: \(word.english)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(isCorrect ? Color.green : Color.red)
                        .shadow(
                            color: (isCorrect ? Color.green : Color.red).opacity(0.25),
                            radius: 10,
                            x: 0,
                            y: 4
                        )
                )
            }
        }
    }
}

// MARK: - MULTIPLE CHOICE MODE

extension ReviewView {
    
    func multipleChoiceView(word: Word) -> some View {
        VStack(spacing: 14) {
            
            ForEach(answers, id: \.self) { answer in
                Button {
                    selectedAnswer = answer
                    showResult = true
                } label: {
                    HStack {
                        Text(answer)
                            .font(.system(size: 16, weight: .medium))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(buttonColor(answer: answer, correct: word.english))
                            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
                    )
                    .foregroundColor(showResult ? .white : .black)
                }
                .disabled(showResult)
            }
        }
    }
}

// MARK: - LOGIC

extension ReviewView {
    
    func generateQuestion() {
        
        guard !manager.words.isEmpty else { return }
        
        currentWord = manager.words.randomElement()
        
        userInput = ""
        selectedAnswer = nil
        showResult = false
        
        if reviewMode == .multipleChoice,
           let word = currentWord {
            
            let wrongAnswers = manager.words
                .filter { $0.id != word.id }
                .shuffled()
                .prefix(3)
                .map { $0.english }
            
            answers = ([word.english] + wrongAnswers).shuffled()
        }
    }
    
    func normalize(_ text: String) -> String {
        text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }
    
    func checkAnswer(user: String, correct: String) -> Bool {
        normalize(user) == normalize(correct)
    }
    
    func buttonColor(answer: String, correct: String) -> Color {
        if !showResult { return Color(.systemBackground) }
        if answer == correct { return Color.green }
        if answer == selectedAnswer { return Color.red }
        return Color(.systemBackground)
    }
}

// MARK: - BUTTON STYLE

struct Primary3DButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.blue.opacity(0.82)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(
                color: .blue.opacity(configuration.isPressed ? 0.18 : 0.32),
                radius: configuration.isPressed ? 4 : 12,
                x: 0,
                y: configuration.isPressed ? 2 : 6
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
