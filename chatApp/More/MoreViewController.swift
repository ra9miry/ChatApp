import UIKit
import SnapKit

final class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = NetworkManager.shared.getUsernameFromDefaults()
        label.textColor = UIColor(named: "nblack")
        label.font = UIFont(name: "mulish-bold", size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let moreTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        return tv
    }()
    private let icons = ["more1", "more3", "more4", "more5","more6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "nwhite")
    
        view.addSubview(profileLabel)
        view.addSubview(moreTableView)
        
        moreTableView.delegate = self
        moreTableView.dataSource = self
        moreTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        moreTableView.isScrollEnabled = false
        
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
        titleLabel.text = "More"
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
    
    private func setupConstraints() {
        
        profileLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.equalToSuperview().offset(24)
        }
        
        moreTableView.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let iconName = icons[indexPath.row]
        cell.imageView?.image = UIImage(named: iconName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            openChats()
        case 1:
            openPrivacy()
        case 2:
            openInvite()
        case 3:
            openAbout()
        case 4:
            exitYourAccount()
        default:
            break
        }
    }
    
    private func openChats() {
        let controller = ChatsViewController()
        self.present(controller, animated: true)
    }
    
    private func openNotifications() {
    }
    
    private func openPrivacy() {
        let controller = MorePrivacyViewController()
        self.present(controller, animated: true)
    }
    
    private func openInvite() {
        let textToShare = "Check out this awesome app!"
        guard let appURL = URL(string: "https://github.com/ra9miry/ChatApp") else {
            print("Invalid URL")
            return
        }

        let activityItems: [Any] = [textToShare, appURL]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { [weak self] activityType, completed, returnedItems, error in
            guard completed else { return }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func openAbout() {
    }
    
    private func exitYourAccount() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate {
            let startViewController = UINavigationController(rootViewController: StartViewController())
            delegate.window?.rootViewController = startViewController
        }
    }
}
