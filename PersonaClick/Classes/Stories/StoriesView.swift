import Foundation
import UIKit

public protocol StoriesCommunicationProtocol: AnyObject {
    func receiveIosLink(text: String)
    func receiveSelectedProductData(products: StoriesElement)
    func receiveSelectedCarouselProductData(products: StoriesProduct)
}

public protocol StoriesViewLinkProtocol: AnyObject {
    func linkIosExternalUse(url: String)
    func sendStructSelectedStorySlide(storySlide: StoriesElement)
    func structOfSelectedCarouselProduct(product: StoriesProduct)
    func reloadStoriesCollectionSubviews()
    func updateBgColor()
}

public class StoriesView: UIView, UINavigationControllerDelegate {
    
    let cellId = "StoriesCollectionViewPreviewCell"
    
    private var collectionView: UICollectionView = {
        let testFrame = CGRect(x: 0, y: 0, width: 300, height: 113)
        let layout = UICollectionViewFlowLayout()
        //layout.horizontalAlignment = .left
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: 76, height: 113)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        let collectionView = UICollectionView(frame: testFrame, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var stories: [Story]?
    private var settings: StoriesSettings?
    private var sdk: PersonalizationSDK?
    
    public weak var communicationDelegate: StoriesCommunicationProtocol?
    
    private var mainVC: UIViewController?
    private var code: String = ""
    
    private var isInDownloadMode: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
        configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc
    func willEnterForeground() {
    }

    @objc
    func didEnterBackground() {
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 12.0, *) {
            super.traitCollectionDidChange(previousTraitCollection)
            let userInterfaceStyle = traitCollection.userInterfaceStyle
            if UIApplication.shared.applicationState == .inactive {
                switch userInterfaceStyle {
                case .unspecified:
                    DispatchQueue.main.async {
                        self.collectionView.backgroundColor = SdkConfiguration.stories.storiesBlockBackgroundColorChanged_Light
                        self.reloadStoriesCollectionSubviews()
                    }
                case .light:
                    DispatchQueue.main.async {
                        self.collectionView.backgroundColor = SdkConfiguration.stories.storiesBlockBackgroundColorChanged_Light
                        self.reloadStoriesCollectionSubviews()
                    }
                case .dark:
                    DispatchQueue.main.async {
                        self.collectionView.backgroundColor = SdkConfiguration.stories.storiesBlockBackgroundColorChanged_Dark
                        self.reloadStoriesCollectionSubviews()
                    }
                @unknown default:
                    break
                }
            }
        } else {
            DispatchQueue.main.async {
                self.collectionView.backgroundColor = .white
                self.reloadStoriesCollectionSubviews()
            }
        }
    }
    
    private func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StoriesCollectionViewPreviewCell.self, forCellWithReuseIdentifier: StoriesCollectionViewPreviewCell.cellId)
        self.setBgColor()
        UserDefaults.standard.set(false, forKey: "MuteSoundSetting")
    }
    
    public func configure(sdk: PersonalizationSDK, mainVC: UIViewController, code: String) {
        self.sdk = sdk
        self.mainVC = mainVC
        self.code = code
        loadStoriesData()
    }
    
    private func setBgColor() {
        if #available(iOS 13.0, *) {
            if SdkConfiguration.isDarkMode {
                DispatchQueue.main.async {
                    self.collectionView.backgroundColor = SdkConfiguration.stories.storiesBlockBackgroundColorChanged_Dark
                    self.reloadStoriesCollectionSubviews()
                }
            } else {
                DispatchQueue.main.async {
                    self.collectionView.backgroundColor = SdkConfiguration.stories.storiesBlockBackgroundColorChanged_Light
                    self.reloadStoriesCollectionSubviews()
                }
            }
        } else {
            self.collectionView.backgroundColor = .white
            self.reloadStoriesCollectionSubviews()
        }
    }
    
    private func setBgColor(color: String) {
        let hex = color.hexToRGB()
        DispatchQueue.main.async {
            self.collectionView.backgroundColor = UIColor(red: hex.red, green: hex.green, blue: hex.blue, alpha: 0)
        }
    }

    private func loadStoriesData() {
        sdk?.getStories(code: code) { result in
            switch result {
            case let .success(response):
                self.stories = response.stories
                self.settings = response.settings
                //self.setBgColor(color: response.stories.background)
                DispatchQueue.main.async {
                    self.isInDownloadMode = false
                    self.collectionView.reloadData()
                }
            case let .failure(error):
                switch error {
                case let .custom(customError):
                    print("Error:", customError)
                default:
                    print("Error:", error.description)
                }
            }
        }
    }
    
    public func pauseStoryNow() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExternalActionStoryPause"), object: nil)
    }
    
    public func playStoryNow() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ExternalActionStoryPlay"), object: nil)
    }
}

extension StoriesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isInDownloadMode ? 4 : stories?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesCollectionViewPreviewCell.cellId, for: indexPath) as? StoriesCollectionViewPreviewCell else {return UICollectionViewCell()}
        
        if let currentStory = stories?[indexPath.row] {
            
            let storyId = String(currentStory.id)
            let storyName = "story." + storyId
            
            var allStoriesMainArray: [String] = []
            for (index, _) in currentStory.slides.enumerated() {
                //print("Story has \(index + 1): \(currentStory.slides[(index)].id)")
                allStoriesMainArray.append(String(currentStory.slides[(index)].id))
            }
            
            let watchedStoriesArray: [String] = UserDefaults.standard.getValue(for: UserDefaults.Key(storyName)) as? [String] ?? []
            if (watchedStoriesArray.count == allStoriesMainArray.count) {
                cell.configureCell(settings: settings, viewed: currentStory.viewed, viewedLocalKey: true, storyId: currentStory.id)
                cell.configure(story: currentStory)
            } else {
                cell.configureCell(settings: settings, viewed: currentStory.viewed, viewedLocalKey: false, storyId: currentStory.id)
                cell.configure(story: currentStory)
            }
        }
        
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentStory = stories?[indexPath.row] {
            let storyVC = StoryViewController()
            storyVC.sdkLinkDelegate = self
            storyVC.sdk = sdk
            storyVC.stories = stories ?? []
            
            let sId = "story." + String(currentStory.id)
            
            var allStoriesMainArray: [String] = []
            for (index, _) in currentStory.slides.enumerated() {
                allStoriesMainArray.append(String(currentStory.slides[(index)].id))
            }
            
            let watchedStoriesArray: [String] = UserDefaults.standard.getValue(for: UserDefaults.Key(sId)) as? [String] ?? []
            let lastWatchedIndexValue = watchedStoriesArray.last
            
            var currentDefaultIndex = 0
            for name in allStoriesMainArray {
                if name == lastWatchedIndexValue {
                    //print("Story \(name) for index \(currentDefaultIndex)")
                    break
                }
                currentDefaultIndex += 1
            }
            
            if (currentDefaultIndex + 1 < allStoriesMainArray.count) {
                storyVC.currentPosition = IndexPath(row: Int(currentDefaultIndex + 1), section: indexPath.row)
                storyVC.startWithIndexPath = IndexPath(row: Int(currentDefaultIndex + 1), section: indexPath.row)
                storyVC.modalPresentationStyle = .fullScreen
                mainVC?.present(storyVC, animated: true)
                
//                let nav = UINavigationController(rootViewController: mainVC!)
//                window?.rootViewController = nav
//                nav.present(storyVC, animated: true, completion: nil)
                
            } else if (currentDefaultIndex + 1 == allStoriesMainArray.count) {
                storyVC.currentPosition = IndexPath(row: Int(0), section: indexPath.row)
                storyVC.startWithIndexPath = IndexPath(row: Int(0), section: indexPath.row)
                storyVC.modalPresentationStyle = .fullScreen
                mainVC?.present(storyVC, animated: true)
                
//                let nav = UINavigationController(rootViewController: mainVC!)
//                window?.rootViewController = nav
//                nav.present(storyVC, animated: true, completion: nil)
                
            } else {
                storyVC.currentPosition = IndexPath(row: currentStory.startPosition, section: indexPath.row)
                storyVC.startWithIndexPath = IndexPath(row: currentStory.startPosition, section: indexPath.row)
                storyVC.modalPresentationStyle = .fullScreen
                mainVC?.present(storyVC, animated: true)
                
//                let nav = UINavigationController(rootViewController: mainVC!)
//                window?.rootViewController = nav
//                nav.present(storyVC, animated: true, completion: nil)
                
            }
        }
    }
}

extension StoriesView: StoriesViewLinkProtocol {
    public func sendStructSelectedStorySlide(storySlide: StoriesElement) {
        self.communicationDelegate?.receiveSelectedProductData(products: storySlide)
        print("\n\nSDK Received story slide button tap links for external use:")
        printSlideObject(objElementClass: storySlide)
    }
    
    public func structOfSelectedCarouselProduct(product: StoriesProduct) {
        self.communicationDelegate?.receiveSelectedCarouselProductData(products: product)
        print("\n\nSDK Received carousel selected product link for external use:")
        printCarouselObject(objProductClass: product)
    }
    
    public func linkIosExternalUse(url: String) {
        self.communicationDelegate?.receiveIosLink(text: url)
        print("\n\nSDK Received linkIos for external use: \(url)\n\n")
    }

    public func reloadStoriesCollectionSubviews() {
        UICollectionView.performWithoutAnimation {
            self.collectionView.layoutIfNeeded()
            self.collectionView.reloadData()
        }
    }
    
    public func updateBgColor() {
        self.setBgColor()
    }
    
    public func printSlideObject(objElementClass: StoriesElement) {
        print("LinkWeb: \(objElementClass.link ?? "")")
        print("LinkiOS: \(objElementClass.linkIos ?? "")")
        print("LinkAndroid: \(objElementClass.linkAndroid ?? "")")
    }
    
    public func printCarouselObject(objProductClass: StoriesProduct) {
        print("ProductName: \(objProductClass.name)")
        print("ProductUrl: \(objProductClass.url)")
        print("ProductCategory: \(objProductClass.category.name)")
        print("ProductCategoryUrl: \(objProductClass.category.url)")
        print("ProductPrice: \(objProductClass.price)")
        print("ProductPriceFormatted: \(objProductClass.price_formatted)")
        print("ProductPicture: \(objProductClass.picture)\n\n")
    }
}

class CustomCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .red : .white
        }
    }
}

extension UIViewController {
    func embedInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}

extension UIView {
    func fixInView(_ container: UIView!) {
        translatesAutoresizingMaskIntoConstraints = false
        frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
