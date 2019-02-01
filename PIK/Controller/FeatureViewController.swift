import UIKit
import SnapKit

class FeatureViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let infoText = UILabel()
    private let badgeLabel = UILabel()
    private let imageContainer = UIView()
    
    var features = Feature()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageContainer)
        scrollView.addSubview(imageView)
        
        showImage()
        showText()
        showBadgeLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        customNavigationContoller()
    }
    
    // MARK: - Custom style for ViewController
    func customNavigationContoller() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showImage() {
        let imgUrl = NSURL(string: features.getImage())
        
        if imgUrl != nil {
            let data = NSData(contentsOf: imgUrl! as URL)
            imageView.image = UIImage(data: data! as Data)
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageContainer.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.height.equalTo(imageContainer.snp.width)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view).priority(.high)
            make.left.right.equalTo(imageContainer)
            make.height.greaterThanOrEqualTo(imageContainer.snp.height).priority(.required)
            make.bottom.equalTo(imageContainer.snp.bottom)
        }
    }
    
    func showBadgeLabel() {
        
        imageView.addSubview(badgeLabel)
        
        badgeLabel.text = features.getName()
        badgeLabel.font = UIFont.appFontBold(ofSize: 20)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .orange
        badgeLabel.layer.cornerRadius = 3
        badgeLabel.clipsToBounds = true
        
        badgeLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageContainer).inset(20)
            make.bottom.equalTo(imageContainer).inset(20)
        }
    }
    
    func showText() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        let text = features.getDescription()
        
        infoText.font = UIFont.appFont(ofSize: 20)
        infoText.text = text
        infoText.numberOfLines = 0
        
        let textContainer = UIView()
        textContainer.backgroundColor = .clear
        
        scrollView.addSubview(textContainer)
        textContainer.addSubview(infoText)
        
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(scrollView)
        }
        
        infoText.snp.makeConstraints { make in
            make.edges.edges.equalTo(textContainer).inset(20)
        }
    }
}
