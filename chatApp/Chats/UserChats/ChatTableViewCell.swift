import UIKit
import SnapKit

class ChatTableViewCell: UITableViewCell {
    private let avatarLabel = UILabel()
    private let userNameLabel = UILabel()
    private let lastMessageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with chatUser: ChatUser) {
        let initials = String(chatUser.userName.prefix(2)).uppercased()
        avatarLabel.text = initials
        avatarLabel.backgroundColor = generateRandomColor()
        userNameLabel.text = chatUser.userName
        lastMessageLabel.text = chatUser.lastMessage
    }
    
    private func setupViews() {
        contentView.addSubview(avatarLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(lastMessageLabel)
        
        avatarLabel.textAlignment = .center
        avatarLabel.textColor = .white
        avatarLabel.layer.cornerRadius = 24
        avatarLabel.clipsToBounds = true
        avatarLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        userNameLabel.font = UIFont(name: "mulish-bold", size: 18)
        userNameLabel.textColor = UIColor(named: "nblack")
        
        lastMessageLabel.font = UIFont.systemFont(ofSize: 14)
        lastMessageLabel.textColor = .gray
    }
    
    private func setupConstraints() {
        avatarLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
        }
        
        lastMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel.snp.leading)
            make.trailing.equalTo(userNameLabel.snp.trailing)
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
        }
    }
    
    private func generateRandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
