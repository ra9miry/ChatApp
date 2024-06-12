import UIKit
import SnapKit

struct ChatUser: Codable {
    var avatarName: String
    var userName: String
    var lastMessage: String
}

final class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, AddedChatsViewControllerDelegate {

    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(named: "nlightgray")
        tf.layer.cornerRadius = 12
        tf.clipsToBounds = true
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.placeholder = "Search Chats"
        tf.setLeftPaddingPoints(20)
        tf.setPlaceholder(color: UIColor(named: "ngray") ?? .gray)
        tf.inputAccessoryView = createDoneToolbar()
        tf.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return tf
    }()
    
    private let chatsTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
        tv.rowHeight = 60
        return tv
    }()
    
    private var chatUsers: [ChatUser] = [] {
        didSet {
            saveChatUsersToDefaults()
        }
    }
    private var filteredChatUsers: [ChatUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "nwhite")
        
        view.addSubview(searchTextField)
        view.addSubview(chatsTableView)
        
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        setupConstraints()
        loadChatUsersFromDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)
        configureNavigationBarForSettings()
    }
    
    private func configureNavigationBarForSettings() {
        let navigationBarAppearance = createNavigationBarAppearance()
        applyAppearanceToNavigationBar(appearance: navigationBarAppearance)
        configureCenteredTitle()
        configureRightBarButton()
    }

    private func configureCenteredTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Chats"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor(named: "nblack")
        titleLabel.sizeToFit()
        
        let leftBarItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftBarItem
    }

    private func configureRightBarButton() {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(UIImage(systemName: "plus"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        rightButton.tintColor = UIColor(named: "nblack")
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc func rightButtonTapped() {
        let addedChatsVC = AddedChatsViewController()
        addedChatsVC.delegate = self
        let navigationController = UINavigationController(rootViewController: addedChatsVC)
        present(navigationController, animated: true, completion: nil)
    }

    private func createNavigationBarAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "nwhite")
        return appearance
    }

    private func applyAppearanceToNavigationBar(appearance: UINavigationBarAppearance) {
        if #available(iOS 15, *) {
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
        } else {
            navigationController?.navigationBar.standardAppearance = appearance
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        chatsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func saveChatUsersToDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.saveChatUsers(chatUsers)
    }
    
    private func loadChatUsersFromDefaults() {
        let userDefaults = UserDefaults.standard
        if let loadedUsers = userDefaults.loadChatUsersArray() {
            chatUsers = loadedUsers
            filteredChatUsers = chatUsers
            chatsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChatUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredChatUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let messagesVC = MessagesViewController()
        messagesVC.chatId = indexPath.row
        messagesVC.title = filteredChatUsers[indexPath.row].userName
        navigationController?.pushViewController(messagesVC, animated: true)
    }
    
    @objc private func searchTextChanged() {
        guard let searchText = searchTextField.text?.lowercased() else {
            filteredChatUsers = chatUsers
            chatsTableView.reloadData()
            return
        }
        if searchText.isEmpty {
            filteredChatUsers = chatUsers
        } else {
            filteredChatUsers = chatUsers.filter { $0.userName.lowercased().contains(searchText) }
        }
        chatsTableView.reloadData()
    }
    
    private func createDoneToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexSpace, doneButton]
        return toolbar
    }
    
    @objc private func doneButtonTapped() {
        searchTextField.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: chatsTableView) {
            return false
        }
        return true
    }

    // MARK: - AddedChatsViewControllerDelegate
    func didAddUserToChat(_ user: User) {
        let chatUser = ChatUser(avatarName: "defaultAvatar", userName: user.username, lastMessage: "")
        chatUsers.append(chatUser)
        filteredChatUsers = chatUsers
        chatsTableView.reloadData()
    }
}
