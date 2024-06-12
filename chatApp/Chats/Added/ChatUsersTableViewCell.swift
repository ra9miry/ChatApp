import UIKit
import SnapKit

final class ChatUsersTableViewCell: UITableViewCell {
    private let avatarLabel = UILabel()
    private let userNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User) {
        let initials = String(user.username.prefix(2)).uppercased()
        avatarLabel.text = initials
        avatarLabel.backgroundColor = generateRandomColor()
        userNameLabel.text = user.username
    }
    
    private func setupViews() {
        contentView.addSubview(avatarLabel)
        contentView.addSubview(userNameLabel)
        
        avatarLabel.textAlignment = .center
        avatarLabel.textColor = .white
        avatarLabel.layer.cornerRadius = 24
        avatarLabel.clipsToBounds = true
        avatarLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        userNameLabel.font = UIFont(name: "mulish-bold", size: 18)
        userNameLabel.textColor = UIColor(named: "nblack")
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
            make.centerY.equalToSuperview()
        }
    }
    
    private func generateRandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
