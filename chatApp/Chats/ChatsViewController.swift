
import UIKit
import SnapKit

struct ChatUser {
    var avatarName: String
    var userName: String
    var lastMessage: String
    var hasUnreadMessage: Bool
}

final class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(named: "nlightgray")
        tf.layer.cornerRadius = 12
        tf.clipsToBounds = true
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.placeholder = "Search Chats"
        tf.setLeftPaddingPoints(20)
        tf.setPlaceholder(color: UIColor(named: "ngray") ?? .gray)
        return tf
    }()
    private let chatsTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
        tv.rowHeight = 60
        return tv
    }()
    private var chatUsers: [ChatUser] = [
        ChatUser(avatarName: "ava1", userName: "Athalia Putri", lastMessage: "Good morning, did you sleep well?", hasUnreadMessage: true),
        ChatUser(avatarName: "ava2", userName: "Raki Devon", lastMessage: "How is it going?", hasUnreadMessage: false),
        ChatUser(avatarName: "ava3", userName: "Erlan Sadewa", lastMessage: "Aight, noted", hasUnreadMessage: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "nwhite")
        
        view.addSubview(searchTextField)
        view.addSubview(chatsTableView)
        
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupConstraints()
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
        chatsTableView.snp.makeConstraints() { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: chatUsers[indexPath.row])
        return cell
    }
}
