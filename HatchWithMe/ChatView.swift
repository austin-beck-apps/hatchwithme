import SwiftUI

struct Message: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id &&
        lhs.content == rhs.content &&
        lhs.isUser == rhs.isUser &&
        lhs.timestamp == rhs.timestamp
    }
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentInput: String = ""
    @Published var isLoading: Bool = false
    
    private let hatch: Hatch
    
    init(hatch: Hatch) {
        self.hatch = hatch
        // Add initial greeting
        messages.append(Message(
            content: "Hello! I'm your HatchWithMe AI assistant. I can help you with questions about your \(hatch.birdType.rawValue) hatch, incubation tips, and troubleshooting. What would you like to know?",
            isUser: false,
            timestamp: Date()
        ))
    }
    
    func sendMessage() {
        guard !currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = currentInput
        messages.append(Message(content: userMessage, isUser: true, timestamp: Date()))
        currentInput = ""
        isLoading = true
        
        Task {
            do {
                let response = try await AIAssistantService.shared.getResponse(for: userMessage, context: hatch)
                await MainActor.run {
                    messages.append(Message(content: response, isUser: false, timestamp: Date()))
                    isLoading = false
                }
            } catch {
                print("AI Chat Error: \(error)")
                await MainActor.run {
                    messages.append(Message(
                        content: "Sorry, I encountered an error: \(error.localizedDescription). Please try again later.",
                        isUser: false,
                        timestamp: Date()
                    ))
                    isLoading = false
                }
            }
        }
    }
}

struct ChatView: View {
    let hatch: Hatch
    @StateObject private var viewModel: ChatViewModel
    @FocusState private var isInputFocused: Bool
    
    init(hatch: Hatch) {
        self.hatch = hatch
        _viewModel = StateObject(wrappedValue: ChatViewModel(hatch: hatch))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages) { _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 12) {
                    TextField("Ask a question...", text: $viewModel.currentInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isInputFocused)
                    
                    Button(action: {
                        viewModel.sendMessage()
                        isInputFocused = false
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .disabled(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
                }
                .padding()
            }
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.content)
                .padding()
                .background(message.isUser ? Color.blue : Color(.systemGray6))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(16)
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = message.content
                    }) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
            
            if !message.isUser {
                Spacer()
            }
        }
    }
} 
