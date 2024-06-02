//
//  MessagesTableViewCell.swift
//  chatApp
//
//  Created by Радмир Тельман on 02.06.2024.
//

import UIKit
import SnapKit

final class MessagesTableViewCell: UITableViewCell {
    let messageLabel = UILabel()
    let timestampLabel = UILabel()
    let bubbleBackgroundView = UIView()

    var isIncoming: Bool = false {
        didSet {
            bubbleBackgroundView.backgroundColor = isIncoming ? UIColor(named: "nblue") : UIColor(named: "nwhite")
            messageLabel.textColor = .black
            timestampLabel.textColor = .black

            if isIncoming {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }

    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        print("IntegrationMessageCell init called")
        setupIntegrationViews()
        setupIntegrationConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("IntegrationMessageCell layoutSubviews called")

        let maxWidth = UIScreen.main.bounds.width - leadingConstraint.constant - abs(trailingConstraint.constant)
        messageLabel.preferredMaxLayoutWidth = maxWidth
    }
    
    private func setupIntegrationViews() {
        print("setupIntegrationViews called")
        backgroundColor = .clear
        bubbleBackgroundView.layer.cornerRadius = 16
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)

        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)

        timestampLabel.font = UIFont.systemFont(ofSize: 10)
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timestampLabel)
    }
    
    private func setupIntegrationConstraints() {
        print("setupIntegrationConstraints called")
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            leadingConstraint,
            trailingConstraint,

            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -10),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -10),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 10),
            
            timestampLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: 4),
            timestampLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: 10),
            timestampLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -10),
            timestampLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
