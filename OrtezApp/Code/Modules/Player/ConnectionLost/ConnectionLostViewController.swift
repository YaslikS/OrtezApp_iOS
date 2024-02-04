//
//  ConnectionLostViewController.swift
//  OrtezApp
//
//  Created by Maxim Vekovenko on 30.06.2022.
//

import UIKit
import SnapKit

enum TypeOfView {
    case lostConnection
    case longPause
}


class ConnectionLostViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let item = UILabel()
        item.numberOfLines = 0
        item.textColor = .black
        item.textAlignment = .center
        item.font = .systemFont(ofSize: 16, weight: .bold)
        return item
    }()
    
    lazy var descriptionLabel: UILabel = {
        let item = UILabel()
        item.numberOfLines = 0
        item.textColor = .black
        item.textAlignment = .center
        item.font = .systemFont(ofSize: 16, weight: .regular)
        return item
    }()
    
    lazy var understandButton: UIButton = {
        let item = UIButton()
        item.setTitle("Понятно".uppercased(), for: .normal)
        item.backgroundColor = .black
        item.titleLabel?.textColor = .white
        item.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        item.layer.cornerRadius = 12
        item.clipsToBounds = true
        return item
    }()

    
    public var typeOfView = TypeOfView.lostConnection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserSettings.shared.setPlayerModeActive(value: false)
        setupUI()
    }
    
    private func setupUI() {
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(understandButton)
        
        switch typeOfView {
        case .lostConnection:
            titleLabel.text = "Внимание!\nОртез отключился!"
            descriptionLabel.text = "Проверьте подключение БГС к ортезу и начните процедуру воздействия заново."
            self.view.backgroundColor = UIColor(red: 1.00, green: 0.74, blue: 0.69, alpha: 1.00)
            break
        case .longPause:
            titleLabel.text = "Приложение долго\nнаходилось в режиме паузы."
            descriptionLabel.text = "Начните сеанс заново."
            descriptionLabel.font = .systemFont(ofSize: 16, weight: .bold)
            self.view.backgroundColor = UIColor(red: 0.94, green: 0.90, blue: 0.70, alpha: 1.00)
            break
        }
        
        understandButton.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview().offset(-64)
            make.height.equalTo(46)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(understandButton.snp.top).offset(-96)
        }
        
        titleLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-32)
        }
        
        understandButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
