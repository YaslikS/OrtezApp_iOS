import UIKit

class SaveAlertController: UIViewController {
    
    var closure: ((String,String) -> ())?
    
    private let alertView = UIView()
    private let label = UILabel()
    private let textField = UITextField()
    private let textView = UITextView()
    private let saveButtom = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let backgoundButtonView = UIView()
    private lazy var scrollView = UIScrollView(frame: view.bounds)
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 1
        stack.alignment = .fill
        return stack
    }()
    
    override func viewDidLoad() {
        setUI()
        setupTarget()
    }
    
    override func viewDidLayoutSubviews() {
        resignKeyboard()
        configure()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    deinit {
        removeNotification()
    }
    
    func getText() {
        guard let text = textField.text else { return }
        if !textView.text.isEmpty && !text.isEmpty {
            if let title = textField.text, let description = textView.text {
                closure?(title,description)
            }
        }
    }
    
    func setProgramDescription(programName: String?, programDescription: String?) {
        textField.text = programName ?? ""
        textView.text = programDescription ?? ""
    }
    
    private func resignKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func configure() {
        alertView.backgroundColor = .white
        alertView.alpha = 1
        alertView.layer.cornerRadius = 10
        alertView.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = AppStrings.ProgramsList.saveTheUserProgramm
        textField.backgroundColor = AppTheme.gentleGray
        textField.placeholder = AppStrings.programm
        textField.setRightPaddingPoints(16)
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints(16)
        textView.backgroundColor = AppTheme.gentleGray
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16)
        if textView.text.isEmpty {
            textView.text = AppStrings.description
            textView.textColor = UIColor.lightGray
        }
        saveButtom.setTitle(AppStrings.save, for: .normal)
        cancelButton.setTitle(AppStrings.cancelBtnText, for: .normal)
        cancelButton.setTitleColor(AppTheme.darkBlue, for: .normal)
        saveButtom.setTitleColor(AppTheme.darkBlue, for: .normal)
        saveButtom.backgroundColor = .white
        cancelButton.backgroundColor = .white
        saveButtom.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        backgoundButtonView.backgroundColor = AppTheme.lightGray
        textView.delegate = self
    }
    
    private func setupTarget() {
        cancelButton.addTarget(self, action: #selector(didCancelTap), for: .touchUpInside)
        saveButtom.addTarget(self, action: #selector(didSaveTap), for: .touchUpInside)
    }
    
    @objc private func didCancelTap() {
        self.dismiss(animated: false)
    }
    
    @objc private func didSaveTap() {
        getText()
        self.dismiss(animated: false)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = ((userInfo?[UIResponder.keyboardFrameEndUserInfoKey]) as? NSValue)!.cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardSize.height - 200)
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    @objc private func hideKeyboard() {
        textField.resignFirstResponder()
        textView.resignFirstResponder()
    }
}

extension SaveAlertController {
    private func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(alertView)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(saveButtom)
        alertView.addSubview(label)
        alertView.addSubview(backgoundButtonView)
        alertView.addSubview(textField)
        alertView.addSubview(textView)
        backgoundButtonView.addSubview(stackView    )
        
        backgoundButtonView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            alertView.heightAnchor.constraint(equalToConstant: 280),
            alertView.widthAnchor.constraint(equalToConstant: 270)
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: alertView.topAnchor,constant: 19),
            label.heightAnchor.constraint(equalToConstant: 22),
            label.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 17),
            label.trailingAnchor.constraint(equalTo: alertView.trailingAnchor,constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 24),
            textField.heightAnchor.constraint(equalToConstant: 47),
            textField.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 17),
            textField.trailingAnchor.constraint(equalTo: alertView.trailingAnchor,constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: textField.bottomAnchor,constant: 24),
            textView.heightAnchor.constraint(equalToConstant: 85),
            textView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 17),
            textView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor,constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            backgoundButtonView.topAnchor.constraint(equalTo: textView.bottomAnchor,constant: 16),
            backgoundButtonView.heightAnchor.constraint(equalToConstant: 45),
            backgoundButtonView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            backgoundButtonView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: backgoundButtonView.topAnchor,constant: 1),
            stackView.heightAnchor.constraint(equalToConstant: 44),
            stackView.leadingAnchor.constraint(equalTo: backgoundButtonView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: backgoundButtonView.trailingAnchor)
        ])
    }
}

extension SaveAlertController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = AppStrings.description
            textView.textColor = UIColor.lightGray
        }
    }
}
