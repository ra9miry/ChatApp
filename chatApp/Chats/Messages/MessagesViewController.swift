import UIKit
import SnapKit

final class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var chatId: Int?
    private var messages: [Message] = []
    
    let tableView = UITableView()
    let textField = UITextField()
    let sendButton = UIButton(type: .custom)
    let sendAssetButton = UIButton()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    private var textFieldBottomConstraint: Constraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "nlightgray")
        setupViews()
        setupConstraints()
        configureNavigationBar()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        fetchMessages()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "ngray"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Write your message", attributes: placeholderAttributes)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor(named: "black")
        textField.autocorrectionType = .no
        textField.backgroundColor = UIColor(named: "nwhite")
        textField.delegate = self
        textField.layer.cornerRadius = 12
        view.addSubview(textField)
        
        sendButton.setImage(UIImage(named: "send"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        view.addSubview(sendButton)
        
        sendAssetButton.setImage(UIImage(named: "assplus"), for: .normal)
        sendAssetButton.addTarget(self, action: #selector(sendAssetsButtonTapped), for: .touchUpInside)
        view.addSubview(sendAssetButton)
    }

    @objc func sendButtonTapped() {
        guard let chatId = chatId, let content = textField.text, !content.isEmpty else { return }
        // Implement the send message functionality here
    }
    
    @objc func sendAssetsButtonTapped() {
        // Implement the send assets functionality here
    }
    
    private func fetchMessages() {
        guard let chatId = chatId else { return }
        
        NetworkManager.shared.getChatMessages(chatId: chatId) { [weak self] result in
            switch result {
            case .success(let messages):
                self?.messages = messages
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch messages: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(textField.snp.top).offset(-10)
        }
        textField.snp.makeConstraints { make in
            self.textFieldBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16).constraint
            make.leading.equalTo(sendAssetButton.snp.trailing).offset(10)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.height.equalTo(50)
        }
        sendAssetButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(textField.snp.leading).offset(-8)
            make.size.equalTo(24)
        }
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(30)
        }
    }
    
    private func configureNavigationBar() {
        configureLeftAlignedTitle()
        configureBackButton()
        let appearance = createTransparentNavigationBarAppearance()
        applyAppearanceToNavigationBar(appearance: appearance)
    }
    
    private func configureLeftAlignedTitle() {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = UIColor(named: "nblack")
        titleLabel.sizeToFit()
        let leftBarItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftBarItem
    }

    private func configureBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backBarItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarItem
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func createTransparentNavigationBarAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        return appearance
    }
    
    private func applyAppearanceToNavigationBar(appearance: UINavigationBarAppearance) {
        guard let navigationController = navigationController else { return }
        
        if #available(iOS 15, *) {
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.compactAppearance = appearance
        } else {
            navigationController.navigationBar.standardAppearance = appearance
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let safeAreaBottomInset = view.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self = self else { return }
                let offset = -(keyboardHeight - safeAreaBottomInset + 16)
                self.textFieldBottomConstraint?.update(offset: offset)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.textFieldBottomConstraint?.update(offset: -16)
            self.view.layoutIfNeeded()
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessagesTableViewCell
        let message = messages[indexPath.row]
        cell.configure(with: message, dateFormatter: dateFormatter)
        return cell
    }
}
