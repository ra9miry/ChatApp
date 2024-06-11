import UIKit
import Contacts
import ContactsUI
import SnapKit

final class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {

    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(named: "nlightgray")
        tf.layer.cornerRadius = 12
        tf.clipsToBounds = true
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.placeholder = "Search Contacts"
        tf.setLeftPaddingPoints(20)
        tf.setPlaceholder(color: UIColor(named: "ngray") ?? .gray)
        tf.inputAccessoryView = createDoneToolbar()
        tf.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return tf
    }()
    
    private let chatsTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.register(ContactsTableViewCell.self, forCellReuseIdentifier: "ContactsTableViewCell")
        tv.rowHeight = 60
        tv.backgroundColor = UIColor(named: "nwhite")
        return tv
    }()
    
    private var chatUsers: [YourContacts] = []
    private var filteredChatUsers: [YourContacts] = []
    
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
        requestContactsAccess()
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
        titleLabel.text = "Contacts"
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
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
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

    private func requestContactsAccess() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                self.fetchContacts()
            } else {
                print("Access denied")
            }
        }
    }

    private func fetchContacts() {
        let store = CNContactStore()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        do {
            try store.enumerateContacts(with: request) { contact, stop in
                let userName = "\(contact.givenName) \(contact.familyName)"
                let avatarInitial = String(contact.givenName.prefix(1))
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
                let contact = YourContacts(avatarInitial: avatarInitial, userName: userName, phoneNumber: phoneNumber)
                self.chatUsers.append(contact)
            }
            DispatchQueue.main.async {
                self.filteredChatUsers = self.chatUsers
                self.chatsTableView.reloadData()
            }
        } catch {
            print("Failed to fetch contacts:", error)
        }
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChatUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as? ContactsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredChatUsers[indexPath.row])
        cell.backgroundColor = UIColor(named: "nwhite")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let phoneNumber = filteredChatUsers[indexPath.row].phoneNumber
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Unable to make a call.")
        }
    }
    
    // CNContactPickerDelegate methods
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let userName = "\(contact.givenName) \(contact.familyName)"
        let avatarInitial = String(contact.givenName.prefix(1))
        let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
        let contact = YourContacts(avatarInitial: avatarInitial, userName: userName, phoneNumber: phoneNumber)
        self.chatUsers.append(contact)
        self.filteredChatUsers = chatUsers
        self.chatsTableView.reloadData()
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Contact picker was cancelled")
    }
    
    // MARK: - Helper Methods
    
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

    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view.isDescendant(of: chatsTableView) {
            return false
        }
        return true
    }
}
