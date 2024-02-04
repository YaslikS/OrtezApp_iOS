import UIKit

final class CustomNavigationController: UINavigationController {
    
    public init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        modalPresentationStyle = .fullScreen
        navigationBar.tintColor = AppTheme.NavigationBar.tintColor
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openViewController(viewController: UIViewController, animated: Bool) {
        viewController.modalPresentationStyle = .fullScreen
        pushViewController(viewController, animated: animated)
    }
    
}
