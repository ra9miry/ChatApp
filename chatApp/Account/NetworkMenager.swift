import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let password: String
    var messages: [Message] = []
    var chats: [Chat] = []
    var chatParticipants: [ChatParticipant] = []

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case password
    }
}

struct Message: Codable { }
struct Chat: Codable { }
struct ChatParticipant: Codable { }

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let baseURL = "http://localhost:3000"

    func register(username: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["username": username, "email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            print("HTTP Status Code: \(httpResponse.statusCode)")
            print("Response: \(String(data: data, encoding: .utf8) ?? "No response")")

            if httpResponse.statusCode == 201 {
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.saveUserToDefaults(user)
                    completion(.success(user))
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            } else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Failed to register"
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }

        task.resume()
    }

    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/name/\(username)") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            print("HTTP Status Code: \(httpResponse.statusCode)")
            print("Response: \(String(data: data, encoding: .utf8) ?? "No response")")

            if httpResponse.statusCode == 200 {
                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    if let user = users.first, user.password == password {
                        self.saveUserToDefaults(user)
                        completion(.success(user))
                    } else {
                        completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid username or password"])))
                    }
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            } else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Failed to login"
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }

        task.resume()
    }

    private func saveUserToDefaults(_ user: User) {
        let defaults = UserDefaults.standard
        defaults.set(user.username, forKey: "username")
    }

    func getUsernameFromDefaults() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "username")
    }
}
