import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let email: String
    let password: String
    let messages: [Message] = []
    let chats: [Chat] = []
    let chatParticipants: [ChatParticipant] = []
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
        print("Request Body: \(body)")

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                print("Response: \(String(data: data, encoding: .utf8) ?? "No response")")
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch let decodingError {
                    print("Decoding error: \(decodingError.localizedDescription)")
                    completion(.failure(decodingError))
                }
            } else {
                print("Failed to register: \(String(data: data, encoding: .utf8) ?? "Unknown error")")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to register"])))
            }
        }

        task.resume()
    }

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "password": password]
        print("Request Body: \(body)")

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                print("Response: \(String(data: data, encoding: .utf8) ?? "No response")")
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode([String: String].self, from: data)
                    if let token = result["access_token"] {
                        completion(.success(token))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No token"])))
                    }
                } catch let decodingError {
                    print("Decoding error: \(decodingError.localizedDescription)")
                    completion(.failure(decodingError))
                }
            } else {
                print("Failed to login: \(String(data: data, encoding: .utf8) ?? "Unknown error")")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to login"])))
            }
        }

        task.resume()
    }
}
