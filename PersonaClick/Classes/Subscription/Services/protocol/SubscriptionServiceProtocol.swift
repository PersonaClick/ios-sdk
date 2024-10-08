
import Foundation

protocol SubscriptionServiceProtocol {
    
    func subscribeForPriceDrop(
        id: String,
        currentPrice: Double,
        email: String?,
        phone: String?,
        completion: @escaping (Result<Void, SdkError>) -> Void
    )
    
    func subscribeForBackInStock(
        id: String,
        email: String?,
        phone: String?,
        fashionSize: String?,
        fashionColor: String?,
        barcode: String?,
        completion: @escaping (Result<Void, SdkError>) -> Void
    )
    
    func unsubscribeForBackInStock(
        itemIds: [String],
        email: String?,
        phone: String?,
        completion: @escaping (Result<Void, SdkError>) -> Void
    )
    
    func unsubscribeForPriceDrop(
        itemIds: [String],
        currentPrice: Double,
        email: String?,
        phone: String?,
        completion: @escaping (Result<Void, SdkError>) -> Void
    )
    
    func manageSubscription(
        email: String?,
        phone: String?,
        userExternalId: String?,
        userLoyaltyId: String?,
        telegramId: String?,
        emailBulk: Bool?,
        emailChain: Bool?,
        emailTransactional: Bool?,
        smsBulk: Bool?,
        smsChain: Bool?,
        smsTransactional: Bool?,
        webPushBulk: Bool?,
        webPushChain: Bool?,
        webPushTransactional: Bool?,
        mobilePushBulk: Bool?,
        mobilePushChain: Bool?,
        mobilePushTransactional: Bool?,
        completion: @escaping (Result<Void, SdkError>) -> Void
    )
}
