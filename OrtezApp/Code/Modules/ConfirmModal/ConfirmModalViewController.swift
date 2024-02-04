import UIKit

class ConfirmModalViewController: UIViewController {
    
    enum State {
        case newFreeProgram
    }
    
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameForm: UITextField!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionForm: UITextView!
    
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var buttonsSeparator: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var constraintContentBottomMargin: NSLayoutConstraint!
    
    private let state: State
    let cancelAction: (() -> ())
    let saveAction: (() -> ())
    
    var descriptionFormPlaceholder = ""
    private let contentBottomMargin: CGFloat = 0
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, state: State, cancelAction: @escaping (() -> ()), saveAction: @escaping (() -> ())) {
        self.state = state
        self.cancelAction = cancelAction
        self.saveAction = saveAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = AppTheme.black.withAlphaComponent(0)
        clearView.backgroundColor = AppTheme.black.withAlphaComponent(0.3)
        
        modalView.backgroundColor = AppTheme.white
        modalView.layer.cornerRadius = AppTheme.Modal.cornerRadiusConfirm
        modalView.layer.masksToBounds = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = AppTheme.black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        setTitle()
        
        nameView.backgroundColor = AppTheme.Modal.confirmFormBackground
        nameView.layer.cornerRadius = AppTheme.Modal.cornerRadiusConfirmForm
        
        nameForm.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        nameForm.textColor = AppTheme.black
        nameForm.text = AppStrings.ProgramsList.newProgramBaseName
        nameForm.delegate = self
        
        descriptionView.backgroundColor = AppTheme.Modal.confirmFormBackground
        descriptionView.layer.cornerRadius = AppTheme.Modal.cornerRadiusConfirmForm
        
        descriptionForm.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionForm.textColor = AppTheme.gray
        descriptionForm.delegate = self
        setDescriptio()
        
        separator.backgroundColor = AppTheme.separator
        buttonsSeparator.backgroundColor = AppTheme.separator
        
        cancelButton.setTitle(AppStrings.cancelBtnText, for: .normal)
        cancelButton.setTitleParams(color: AppTheme.SecondButton.titleColor, highlightedColor: AppTheme.SecondButton.highlightedTitleColor, fontSize: 17, fontWeight: .regular)
        cancelButton.addTarget(self, action: #selector(tappedCancel), for: .touchUpInside)
        
        saveButton.setTitle(AppStrings.save, for: .normal)
        saveButton.setTitleParams(color: AppTheme.SecondButton.titleColor, highlightedColor: AppTheme.SecondButton.highlightedTitleColor, fontSize: 17, fontWeight: .semibold)
        saveButton.addTarget(self, action: #selector(tappedSaveButton), for: .touchUpInside)
    }
    
    private func setTitle() {
        switch state {
        case .newFreeProgram:
            titleLabel.text = AppStrings.ProgramsList.saveNewProgram
        }
    }
    
    private func setDescriptio() {
        switch state {
        case .newFreeProgram:
            descriptionFormPlaceholder = AppStrings.ProgramsList.description
            descriptionForm.text = descriptionFormPlaceholder
        }
    }
    
    @objc private func closeModal() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion: { (finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @objc private func tappedCancel(_ sender: UIButton) {
        closeModal()
        cancelAction()
    }
    
    @objc private func tappedSaveButton(_ sender: UIButton) {
        closeModal()
        saveAction()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            constraintContentBottomMargin.constant = contentBottomMargin + keyboardSize.height
        } else {
            constraintContentBottomMargin.constant = contentBottomMargin
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        constraintContentBottomMargin.constant = contentBottomMargin
    }
}

// MARK: UITextFieldDelegate
extension ConfirmModalViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

// MARK: UITextViewDelegate
extension ConfirmModalViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == AppTheme.gray {
            textView.text = nil
            textView.textColor = AppTheme.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionFormPlaceholder
            textView.textColor = AppTheme.gray
        }
    }
    
}
