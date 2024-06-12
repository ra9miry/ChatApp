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

struct Chat: Codable {
    let id: Int
    let participants: [User]
    let messages: [Message]
}

struct Message: Codable {
    let id: Int
    let chatId: Int
    let userId: Int
    let content: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case userId = "user_id"
        case content
        case createdAt = "created_at"
    }
}

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

    func getUserChats(username: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/chats/\(username)") else {
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
                    let chats = try JSONDecoder().decode([Chat].self, from: data)
                    completion(.success(chats))
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            } else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Failed to fetch chats"
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }

        task.resume()
    }

    func getChatMessages(chatId: Int, completion: @escaping (Result<[Message], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/messages/\(chatId)") else {
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
                    let messages = try JSONDecoder().decode([Message].self, from: data)
                    completion(.success(messages))
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            } else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Failed to fetch messages"
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }

        task.resume()
    }
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user") else {
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
                    completion(.success(users))
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            } else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Failed to fetch users"
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }

        task.resume()
    }
    func addUserToChats(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
          completion(.success(()))
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
