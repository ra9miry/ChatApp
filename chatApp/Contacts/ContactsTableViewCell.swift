
import UIKit
import SnapKit

class ContactsTableViewCell: UITableViewCell {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(15)
            make.top.equalTo(avatarImageView.snp.top)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configure(with chatUser: YourContacts) {
        avatarImageView.image = UIImage(named: chatUser.avatarName)
        userNameLabel.text = chatUser.userName
    }
}
