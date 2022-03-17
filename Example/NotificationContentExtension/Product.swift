import Foundation

struct Product {
    var deepUrl: String = ""
    var price: String = ""
    var oldPrice: String?
    var name: String = ""
    var imageUrl: String = ""

    init(json: [String: Any]) {
        deepUrl = json["uri"] as? String ?? ""
        price = json["price"] as? String ?? ""
        oldPrice = json["old_price"] as? String
        name = json["name"] as? String ?? ""
        imageUrl = json["image_url"] as? String ?? ""
    }
}
