//
//  PersonalizationSDK.swift
//

import Foundation

public enum Event {
    case productView (id: String)
    case categoryView (id: String)
    case productAddedToFavorities(id: String)
    case productRemovedToFavorities(id: String)
    case productAddedToCart (id: String)
    case productRemovedFromCart (id: String)
    case synchronizeCart (ids: [String])
    case orderCreated(orderId: String, totalValue: Double, products: [(id: String, amount: Int)])
}

public enum SDKError: Error {
    case incorrectAPIKey
    case initializationFailed
    case noError
    case responseError
    case invalidResponse
    case decodeError
    case custom(error: String)
}


public protocol PersonalizationSDK {
    func setProfileData(userEmail: String, userPhone: String?, userLoyaltyId: String?, birthday: Date?, age: String?, firstName: String?, secondName: String?, lastName: String?, location: String?, gender: Gender?, completion: @escaping (Result<Void, SDKError>) -> Void)
    func track(event: Event, recommendedBy: RecomendedBy?, completion: @escaping (Result<Void, SDKError>) -> Void)
    func trackSource(source: RecommendedByCase, code: String)
    func recommend(blockId: String, currentProductId: String?, locations: String?, imageSize: String?, timeOut: Double?, completion: @escaping (Result<RecommenderResponse, SDKError>) -> Void)
    func suggest(query: String, locations: String?, timeOut: Double?, completion: @escaping(Result<SearchResponse, SDKError>) -> Void)
    func search(query: String, limit: Int?, offset: Int?, categoryLimit: Int?, categories: String?, extended: String?, sortBy: String?, sortDir: String?, locations: String?, brands: String?, filters: [String: Any]?, priceMin: Double?, priceMax: Double?, colors: String?, exclude: String?, email: String?, timeOut: Double?, completion: @escaping(Result<SearchResponse, SDKError>) -> Void)
    func getDeviceID() -> String
    func getSession() -> String
    func setPushTokenNotification(token: String, completion: @escaping(Result<Void, SDKError>) -> Void)
    func review(rate: Int, channel: String, category: String, orderId: String?, comment: String?, completion: @escaping(Result<Void, SDKError>) -> Void)
    func searchBlank(completion: @escaping(Result<SearchBlankResponse, SDKError>) -> Void)
}

public extension PersonalizationSDK {
    
    func review(rate: Int, channel: String, category: String, orderId: String? = nil, comment: String? = nil, completion: @escaping(Result<Void, SDKError>) -> Void) {
            review(rate: rate, channel: channel, category: category, orderId: orderId, comment: comment, completion: completion)
        }


    func setProfileData(userEmail: String, userPhone: String? = nil, userLoyaltyId: String? = nil, birthday: Date? = nil, age: String? = nil, firstName: String? = nil, secondName: String? = nil, lastName: String? = nil, location: String? = nil, gender: Gender? = nil, completion: @escaping (Result<Void, SDKError>) -> Void) {
        setProfileData(userEmail: userEmail, userPhone: userPhone, userLoyaltyId: userLoyaltyId, birthday: birthday, age: age, firstName: firstName, secondName: secondName, lastName: lastName, location: location, gender: gender, completion: completion)
    }

    func recommend(blockId: String, currentProductId: String? = nil, locations: String? = nil, imageSize: String? = nil, timeOut: Double?, completion: @escaping (Result<RecommenderResponse, SDKError>) -> Void) {
        recommend(blockId: blockId, currentProductId: currentProductId, locations: locations, imageSize: imageSize, timeOut: timeOut, completion: completion)
    }
    
    func suggest(query: String, locations: String? = nil, timeOut: Double?, completion: @escaping(Result<SearchResponse, SDKError>) -> Void) {
        suggest(query: query, locations: locations, timeOut: timeOut, completion: completion)
    }

    func search(query: String, limit: Int? = nil, offset: Int? = nil, categoryLimit: Int? = nil, categories: String? = nil, extended: String? = nil, sortBy: String? = nil, sortDir: String? = nil, locations: String? = nil, brands: String? = nil, filters: [String: Any]? = nil, priceMin: Double? = nil, priceMax: Double? = nil, colors: String? = nil, exclude: String? = nil, email: String? = nil, timeOut: Double?, completion: @escaping(Result<SearchResponse, SDKError>) -> Void) {
        search(query: query, limit: limit, offset: offset, categoryLimit: categoryLimit, categories: categories, extended: extended, sortBy: sortBy, sortDir: sortDir, locations: locations, brands: brands, filters: filters, priceMin: priceMin, priceMax: priceMax, colors: colors, exclude: exclude, email: email, timeOut: timeOut, completion: completion)
    }
    
    func track(event: Event, recommendedBy: RecomendedBy? = nil, completion: @escaping (Result<Void, SDKError>) -> Void) {
        track(event: event, recommendedBy: recommendedBy, completion: completion)
    }

}
public func createPersonalizationSDK(shopId: String, userEmail: String? = nil, userPhone: String? = nil, userLoyaltyId: String? = nil, apiDomain: String = "api.personaclick.com", _ completion: ((SDKError?) -> Void)? = nil) -> PersonalizationSDK{
    let sdk = SimplePersonalizationSDK(shopId: shopId, userEmail: userEmail, userPhone: userPhone, userLoyaltyId: userLoyaltyId, apiDomain: apiDomain, completion: completion)
    return sdk
}
