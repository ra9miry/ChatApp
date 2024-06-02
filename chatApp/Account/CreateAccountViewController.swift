import UIKit
import SnapKit

final class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pi")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.backgroundColor = UIColor(named: "nlightgray")
        tf.layer.cornerRadius = 12
        tf.setLeftPaddingPoints(20)
        tf.setPlaceholder(color: UIColor(named: "ngray") ?? .gray)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.backgroundColor = UIColor(named: "nlightgray")
        tf.layer.cornerRadius = 12
        tf.setLeftPaddingPoints(20)
        tf.setPlaceholder(color: UIColor(named: "ngray") ?? .gray)
        return tf
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "save"), for: .normal)
        button.addTarget(self, action: #selector(saveButtonButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "nwhite")
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "yp"), for: .normal)
        backButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        view.addSubview(profileImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(saveButton)
        
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func saveButtonButtonTapped() {
        navigationController?.pushViewController(TabBarViewController(), animated: true)
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func selectProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.centerX.equalToSuperview()
        }
    }
}
