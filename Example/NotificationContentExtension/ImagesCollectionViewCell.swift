import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var oldPriceLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        oldPriceLabel.isHidden = true
        layer.cornerRadius = 8.0
    }

    func configure(product: Product) {
        if let oldPrice = product.oldPrice, !oldPrice.isEmpty {
            oldPriceLabel.isHidden = false
            oldPriceLabel.attributedText = strikeThrough(str: oldPrice)
        } else {
            oldPriceLabel.isHidden = true
        }
        priceLabel.text = product.price
        nameLabel.text = product.name
        setImage(imagePath: product.imageUrl)
    }

    private func strikeThrough(str: String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: str)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }

    private func setImage(imagePath: String) {
        guard let url = URL(string: imagePath) else {
            print("Failed to present attachment due to an invalid url: ", imagePath)
            return
        }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            if error == nil {
                guard let unwrappedData = data, let image = UIImage(data: unwrappedData) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        })
        task.resume()
    }
}
