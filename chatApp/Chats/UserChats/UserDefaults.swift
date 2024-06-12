import Foundation

extension UserDefaults {
    private enum Keys {
        static let chatUsersArray = "chatUsersArray"
    }

    func saveChatUsers(_ users: [ChatUser]) {
        if let data = try? JSONEncoder().encode(users) {
            set(data, forKey: Keys.chatUsersArray)
        }
    }

    func loadChatUsersArray() -> [ChatUser]? {
        if let data = data(forKey: Keys.chatUsersArray),
           let users = try? JSONDecoder().decode([ChatUser].self, from: data) {
            return users
        }
        return nil
    }
}
