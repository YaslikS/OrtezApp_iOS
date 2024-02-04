import UIKit

extension UIViewController {
    
    func openModalViewController(viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.frame
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func returnBackViewController() {
        let programmViewController = ProgramsListViewController()
        guard let window = AppDelegate.shared.window?.rootViewController else { return }
        window.setRootViewController(viewController: programmViewController, animation: true)
    }
    
    func setRootViewController(viewController: UIViewController, animation: Bool = false) {
        guard let window = UIApplication.shared.windows.first else { return }
        
        viewController.modalPresentationStyle = .fullScreen
        let navigationController = CustomNavigationController(viewControllers: [viewController])
        window.rootViewController = navigationController
        
        if animation {
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.25
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
                                { completed in
                window.makeKeyAndVisible()
            })
        } else {
            window.makeKeyAndVisible()
        }
    }
}

extension UIViewController {
        
    func alert(programName: String? = nil, programDescription: String? = nil, closure: @escaping (String,String) -> Void) {
        let alert = SaveAlertController()
        alert.setProgramDescription(programName: programName, programDescription: programDescription)
        alert.closure = {title, description in
            closure(title,description)
        }
        
        alert.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.present(alert, animated: false, completion: nil)

        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: AppStrings.close, style: .destructive, handler: { _ in })
        cancelAction.setValue(AppTheme.darkBlue, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
