# PersonaClick SDK

[![Version](https://img.shields.io/cocoapods/v/PersonaClick.svg?style=flat)](https://cocoapods.org/pods/PersonaClick)
[![License](https://img.shields.io/cocoapods/l/PersonaClick.svg?style=flat)](https://cocoapods.org/pods/PersonaClick)
[![Platform](https://img.shields.io/cocoapods/p/PersonaClick.svg?style=flat)](https://cocoapods.org/pods/PersonaClick)

## Installation

PersonaClick SDK is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'PersonaClick'
```

## Swift Package Manager

If you are using Xcode 11 or later:
1. Click `File`
2. `Swift Packages`
3. `Add Package Dependency...`
4. Specify the git URL for PersonaClick SDK repo.

```ruby
https://github.com/PersonaClick/ios-sdk.git
```

# Usage

SDK is used for several tasks:

1. Initialize SDK and user's session
2. Events tracking
3. Product recommendations
4. Product search
5. Populate user's profile with new data
6. Send mobile push token
7. Utilities

## Initialization

Initialize SDK object and use it anywhere in your application. (!) Remember to initialize SDK only once on application launch.

```swift
import PersonaClick
.....
var sdk = createPersonalizationSDK(shopId: "API_KEY")
```

## Events tracking

Track user's behavior to collect data. There are several types of events:

### User viewed a product

```swift
sdk.track(event: .productView(id: "PRODUCT_ID")) { _ in
  print("Product view callback")
}
```

### User viewed a category

```swift
sdk.track(event: .categoryView(id: "CATEGORY_ID")) { _ in
  print("Category view callback")
}
```

### User added a product to wish list

```swift
sdk.track(event: .productAddedToFavorities(id: "PRODUCT_ID")) { _ in
  print("Product is added to wish list callback")
}
```

### User removed a product from wish list

```swift
sdk.track(event: .productRemovedToFavorities(id: "PRODUCT_ID")) { _ in
  print("Product is removed from wish list callback")
}
```

### User added a product to shopping cart

```swift
sdk.track(event: .productAddedToCart(id: "PRODUCT_ID")) { _ in
  print("Product is added to cart callback")
}
```

### User removed a product from shopping cart

```swift
sdk.track(event: .productRemovedFromCart(id: "PRODUCT_ID")) { _ in
  print("Product is removed from cart callback")
}
```

### Synchronize shopping cart

This method is used to override current state of user's shopping cart. It's easier to sync cart with API using this method, than `productAddedToCart` and `productRemovedFromCart` methods.

```swift
sdk.track(event: .synchronizeCart(ids: ["PRODUCT_1_ID", "PRODUCT_2_ID"])) { _ in
  print("Cart is synced callback")
}
```

### User is made a purchase

```swift
sdk.track(event: .orderCreated(orderId: "ORDER_ID", totalValue: 33.3, products: [(id: "PRODUCT_1_ID", amount: 3), (id: "PRODUCT_2_ID", amount: 1)])) { _ in
  print("Order is created callback")
}
```

## Product recommendations

You can use recommender engine in two ways:

1. Simple block request
2. Request with additional data

### Simple request

```swift
sdk.recommend(blockId: "BLOCK_ID") { recommendResult in
  print("Callback")
}
```

### Request with additional data

For example, you can provide current product ID (to exclude it from recommended products when user sees this product's details page):

```swift
sdk.recommend(blockId: "block_id", currentProductId: "PRODUCT_ID") { recommendResult in
  print("Callback")
}
```

## Product search

We have 2 types of search:

1. Suggest (or typeahead)
2. Full search

### Suggest

```swift
sdk.suggest(query: "ipho") { searchResult in
  print("Suggest callback")
}
```

### Full search

Full search can be performed as simple query and query with filter parameters.

Simple full search:

```swift
sdk.search(query: "iphone") { searchResult in
  print("Full search callback")
}
```

Full search with additional filters:

```swift
sdk.search(query: "laptop", limit: nil, offset: nil, categoryLimit: nil, categories: nil, extended: nil, sortBy: nil, sortDir: nil, locations: nil, brands: nil, filters: nil, priceMin: nil, priceMax: nil, colors: nil, exclude: nil) { searchResult in
  print("Full search callback")
}
```

Parameters list:

Parameter | Required | Description
--------- | ------- | -----------
query | true | Search query
limit | false | Limit of results
offset | false | Offset of results
categoryLimit | false | How many categories for sidebar filter to return
categories | false | Dictionary categories list to filter products by
extended | false | It's better to use `true` for full search results
sortBy | false | Sort by parameter: `popular`, `price`, `discount`
sortDir | false | Sort direction: `asc` or `desc` (default)
locations | false | Dictionary list of locations IDs
brands | false | Dictionary list of brands to filter
filters | false | JSON object with filter parameters. For example: ["bluetooth":["yes"],"offers":["15% cashback"],"weight":["1.6"]]
priceMin | false | Min price
priceMax | false | Max price
colors | false | Dictionary list of colors
exclude | false | Dictionary list of products IDs to exclude from search results

Output:

```swift
categories = [Category];
products =  [Product];
productsTotal =  Int;
queries = [Query];
```

## Populate user's profile with new data

You can populate user's profile with additional data.

For example, save email to user's profile:

```swift
sdk.setProfileData(userEmail: "EMAIL@EXAMPLE.COM") { (profileDataResp) in
    print("Profile data callback")
 }
```

Or you can provide more data:

```swift
sdk.setProfileData(userEmail: "EMAIL@EXAMPLE.COM", userPhone: "+111111111111", userLoyaltyId: "LOYALTY_CARD_ID", birthday: nil, age: nil, firstName: "Johny", secondName: nil, lastName: "Cash", location: nil, gender: .male) { (profileDataResp) in
  print("Profile data callback")
 }
```


## Send mobile push token

```swift
sdk.setPushTokenNotification(token: "TOKEN_STRING") { (tokenResponse) in
  print("Token set response")
}
```

## Utilities

These method are used for debug tasks. You don't need it for common tasks.

### Get session ID

```swift
let ssid = sdk.getSSID()
```

## Author

PersonaClick, «support@personaclick.com»

## License

PersonaClick SDK is available under the MIT license. See the LICENSE file for more info.
