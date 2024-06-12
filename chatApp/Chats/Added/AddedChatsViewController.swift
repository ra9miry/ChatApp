import UIKit
import SnapKit

protocol AddedChatsViewControllerDelegate: AnyObject {
    func didAddUserToChat(_ user: User)
}

final class AddedChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    weak var delegate: AddedChatsViewControllerDelegate?

    private lazy var searchUsersTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(named: "nlightgray")
        tf.layer.cornerRadius = 12
        tf.clipsToBounds = true
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.placeholder = "Search Users"
        tf.setLeftPaddingPoints(20)
        tf.setPlaceholder(color: UIColor(named: "ngray") ?? .gray)
        tf.inputAccessoryView = createDoneToolbar()
        tf.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return tf
    }()
    
    private let chatsUsersTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.register(ChatUsersTableViewCell.self, forCellReuseIdentifier: "ChatUserTableViewCell")
        tv.rowHeight = 60
        return tv
    }()
    
    private var users: [User] = []
    private var filteredUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "nwhite")
        
        view.addSubview(searchUsersTextField)
        view.addSubview(chatsUsersTableView)
        
        chatsUsersTableView.delegate = self
        chatsUsersTableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        setupConstraints()
        fetchUsers()
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
        titleLabel.text = "All Users"
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
        searchUsersTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        chatsUsersTableView.snp.makeConstraints { make in
            make.top.equalTo(searchUsersTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func fetchUsers() {
        NetworkManager.shared.getAllUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.filteredUsers = users
                DispatchQueue.main.async {
                    self?.chatsUsersTableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch users: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserTableViewCell", for: indexPath) as? ChatUsersTableViewCell else {
            return UITableViewCell()
        }
        let user = filteredUsers[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = filteredUsers[indexPath.row]
        delegate?.didAddUserToChat(user)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func searchTextChanged() {
        guard let searchText = searchUsersTextField.text?.lowercased() else {
            filteredUsers = users
            chatsUsersTableView.reloadData()
            return
        }
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { $0.username.lowercased().contains(searchText) }
        }
        chatsUsersTableView.reloadData()
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
        searchUsersTextField.resignFirstResponder()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: chatsUsersTableView) {
            return false
        }
        return true
    }
}
