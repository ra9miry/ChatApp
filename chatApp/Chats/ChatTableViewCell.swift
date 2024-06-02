//
//  ChatTableViewCell.swift
//  chatApp
//
//  Created by Радмир Тельман on 02.06.2024.
//

import UIKit
import SnapKit

class ChatTableViewCell: UITableViewCell {
    
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
    
    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
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
        addSubview(lastMessageLabel)
        
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
        
        lastMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel.snp.leading)
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(userNameLabel.snp.trailing)
        }
        
    }
    
    func configure(with chatUser: ChatUser) {
        avatarImageView.image = UIImage(named: chatUser.avatarName)
        userNameLabel.text = chatUser.userName
        lastMessageLabel.text = chatUser.lastMessage
    }
}
