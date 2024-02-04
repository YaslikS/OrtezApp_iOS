//
//  InfoViewCintroller.swift
//  OrtezApp
//
//  Created by Александр Александрович on 17.08.2022.
//

import Foundation
import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        title = AppStrings.user
        firstLabel.text = AppStrings.first
        secondLabel.text = AppStrings.second
        thirdLabel.text = AppStrings.third
        fourthLabel.text = AppStrings.fourth
    }
}
