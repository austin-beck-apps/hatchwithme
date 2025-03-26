import Foundation

class AIAssistantService {
    static let shared = AIAssistantService()
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    private init() {
        self.apiKey = Config.openAIKey
    }
    
    func getResponse(for question: String, context: Hatch) async throws -> String {
        let prompt = createPrompt(for: question, context: context)
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are an expert in egg incubation and hatching, specializing in \(context.birdType.rawValue) eggs. Provide accurate, helpful advice based on scientific principles and best practices."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 500
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AIError.invalidResponse
            }
            
            print("API Response Status: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let error = errorJson["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    throw AIError.apiError(message)
                }
                throw AIError.requestFailed
            }
            
            let result = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            return result.choices.first?.message.content ?? "Sorry, I couldn't generate a response."
        } catch {
            print("API Request Error: \(error)")
            throw error
        }
    }
    
    private func createPrompt(for question: String, context: Hatch) -> String {
        return """
        Context:
        - Bird Type: \(context.birdType.rawValue)
        - Incubation Temperature: \(context.birdType.incubationTemperature)°F
        - Incubation Humidity: \(context.birdType.incubationHumidity)%
        - Turn Frequency: \(context.birdType.turnFrequency) times per day
        - Lockdown Days: \(context.birdType.lockdownDays) days before hatch
        - Lockdown Humidity: \(context.birdType.lockdownHumidity)%
        - Candling Days: \(context.birdType.candlingDays) days
        - Current Status: \(context.hasHatched ? "Hatched" : context.inLockdown ? "In Lockdown" : "Incubating")
        
        Question: \(question)
        
        Please provide a detailed, accurate response based on the context and question.
        """
    }
    
    func getHatchRecommendations(for hatch: Hatch) async throws -> String {
        let isLockdown = Date() >= hatch.lockdownDate
        let settings = HatchViewModel.shared.recommendedSettings(for: hatch.birdType)
        
        return """
        Based on your \(hatch.birdType) hatch:
        - Current stage: \(isLockdown ? "Lockdown" : "Incubation")
        - Recommended temperature: \(settings.temperature)
        - Recommended humidity: \(settings.humidity)
        
        Additional recommendations:
        - Make sure to turn eggs \(isLockdown ? "no longer needed" : "3-5 times daily")
        - Monitor temperature and humidity closely
        - Keep detailed notes of any observations
        """
    }
}

enum AIError: LocalizedError {
    case requestFailed
    case invalidResponse
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .requestFailed:
            return "Failed to make API request"
        case .invalidResponse:
            return "Invalid response from API"
        case .apiError(let message):
            return "API Error: \(message)"
        }
    }
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
} 
