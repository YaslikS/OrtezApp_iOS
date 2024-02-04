import UIKit

class DevicesPreviewViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var linkButton: UIButton!
    
    var widthImageCell: CGFloat = 0
    let marginItemSide: CGFloat = 16
    let sizeItemRadio: CGFloat = 1.87
    
    private var items: [DevicePreview] = [
        DevicePreview(name: AppStrings.DevicesPreview.nameDevice1, description: AppStrings.DevicesPreview.descriptionDevice1, image: "device_1"),
        DevicePreview(name: AppStrings.DevicesPreview.nameDevice2, description: AppStrings.DevicesPreview.descriptionDevice2, image: "device_2"),
        DevicePreview(name: AppStrings.DevicesPreview.nameDevice3, description: AppStrings.DevicesPreview.descriptionDevice3, image: "device_3"),
        DevicePreview(name: AppStrings.DevicesPreview.nameDevice4, description: AppStrings.DevicesPreview.descriptionDevice4, image: "device_4"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        title = AppStrings.Device.devicesPreview
        
        widthImageCell = (UIScreen.main.bounds.width - (marginItemSide * 3)) / 2
        
        // collectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 12
        collectionView.collectionViewLayout = layout
        
        collectionView.register(DevicesPreviewCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        linkButton.setTitle(AppStrings.Device.devicesPreviewTextLink, for: .normal)
        linkButton.setTitleParams(color: AppTheme.SecondButton.titleColor, highlightedColor: AppTheme.SecondButton.highlightedTitleColor, fontSize: 14, fontWeight: .semibold)
        linkButton.addTarget(self, action: #selector(tappedLinkButton), for: .touchUpInside)
        
        if let titleLabel = linkButton.titleLabel {
            let attributedString = NSMutableAttributedString(string: titleLabel.text ?? AppStrings.Device.devicesPreviewTextLink)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            titleLabel.attributedText = attributedString
            
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
        }
    }
    
    @objc private func tappedLinkButton(_ sender: UIButton) {
        guard let url = URL(string: AppStrings.Urls.ortezURL) else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

// MARK: UICollectionViewDelegate
extension DevicesPreviewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = widthImageCell * sizeItemRadio
        return CGSize(width: widthImageCell, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DevicesPreviewCollectionCell else { return UICollectionViewCell() }
        
        let isOddItem = (indexPath.row % 2) != 0
        cell.set(device: items[indexPath.row], isOddItem: isOddItem, widthImageCell: widthImageCell)
        return cell
    }
    
}
