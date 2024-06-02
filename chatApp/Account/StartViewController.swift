import UIKit
import SnapKit

final class StartViewController: UIViewController {

    private var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "main")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the messenger for communication with friends and family"
        label.textColor = UIColor(named: "nblack")
        label.font = UIFont(name: "mulish-bold", size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "in"), for: .normal)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "up"), for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "nwhite")
        
        view.addSubview(mainImageView)
        view.addSubview(mainLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        setupConstraints()
    }
    
    @objc func signInButtonTapped() {
        navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    @objc func signUpButtonTapped() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    private func setupConstraints() {
        mainImageView.snp.makeConstraints() { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
        }
        mainLabel.snp.makeConstraints() { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        signInButton.snp.makeConstraints() { make in
            make.bottom.equalTo(signUpButton.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        signUpButton.snp.makeConstraints() { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
        }
    }
}
