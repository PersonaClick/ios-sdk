import Foundation
import UIKit

class SubscriptionServiceImpl: SubscriptionServiceProtocol {
  
  private var sdk: PersonalizationSDK?
  private var sessionQueue: SessionQueue
  private let validator = ContactValidator()
  typealias RequesParams = [String: Any]
  
  init(sdk: PersonalizationSDK) {
    self.sdk = sdk
    self.sessionQueue = sdk.sessionQueue
  }
  
  private struct Constants {
    static let subscribeForProductPricePath = "subscriptions/subscribe_for_product_price"
    static let unSubscribeForProductPricePath = "subscriptions/unsubscribe_from_product_price"
    
    static let subscribePath = "subscriptions/subscribe_for_product_available"
    static let unsubscribePath = "subscriptions/unsubscribe_from_product_available"
    
    static let manageSubscriptionPath = "subscriptions/manage"
    
    static let shopId = "shop_id"
    static let did = "did"
    static let seance = "seance"
    static let sid = "sid"
    static let segment = "segment"
    static let itemId = "item_id"
    static let itemIds = "item_ids"
    static let properties = "properties"
    static let fashionSize = "fashion_size"
    static let fashionColor = "fashion_color"
    static let barcode = "barcode"
    static let email = "email"
    static let phone = "phone"
    static let price = "price"
    
    static let externalId = "external_id"
    static let loyaltyId = "loyalty_id"
    static let telegramId = "telegram_id"
    static let emailBulk = "email_bulk"
    static let emailChain = "email_chain"
    static let emailTransactional = "email_transactional"
    static let smsBulk = "sms_bulk"
    static let smsChain = "sms_chain"
    static let smsTransactional = "sms_transactional"
    static let webPushBulk = "web_push_bulk"
    static let webPushChain = "web_push_chain"
    static let webPushTransactional = "web_push_transactional"
    static let mobilePushBulk = "mobile_push_bulk"
    static let mobilePushChain = "mobile_push_chain"
    static let mobilePushTransactional = "mobile_push_transactional"
  }
  
  private func handlePostRequest(
    path: String,
    params: RequesParams,
    completion: @escaping (Result<Void, SdkError>) -> Void
  ) {
    guard let sdk = sdk.checkInitialization(completion: completion) else { return }
    
    sdk.sessionQueue.addOperation {
      sdk.postRequest(path: path, params: params) { result in
        switch result {
        case .success:
          completion(.success(Void()))
        case let .failure(error):
          completion(.failure(error))
        }
      }
    }
  }
  
  private func prepareBasicParams() -> RequesParams? {
    guard let sdk = sdk else { return nil }
    
    return [
      Constants.shopId: sdk.shopId,
      Constants.did: sdk.deviceId,
      Constants.seance: sdk.userSeance,
      Constants.sid: sdk.userSeance,
      Constants.segment: sdk.segment
    ]
  }
  
  
  func subscribeForPriceDrop(
    id: String,
    currentPrice: Double,
    email: String? = nil,
    phone: String? = nil,
    completion: @escaping (Result<Void, SdkError>) -> Void
  ) {
    guard var params = prepareBasicParams() else {
      completion(.failure(.custom(error: "subscribeForPriceDrop: SDK is not initialized")))
      return
    }
    
    params[Constants.itemId] = id
    params[Constants.price] = currentPrice
    
    validator.validate(email: email, phone: phone) { result in
        switch result {
          case .success(let validated):
            params.merge(validated) { _, new in new }
            self.handlePostRequest(
              path: Constants.subscribeForProductPricePath,
              params: params,
              completion: completion
            )
          case .failure(let error):
              self.handleValidationFailure(error: error, actionName: "subscribeForBackInStock", completion: completion)
        }
    }
  }
  
  func subscribeForBackInStock(
    id: String,
    email: String? = nil,
    phone: String? = nil,
    fashionSize: String? = nil,
    fashionColor: String? = nil,
    barcode: String? = nil,
    completion: @escaping (Result<Void, SdkError>) -> Void
  ) {
    guard var params = prepareBasicParams() else {
      completion(.failure(.custom(error: "subscribeForBackInStock: SDK is not initialized")))
      return
    }
    
    params[Constants.itemId] = id
    
    var properties: [String: String] = [:]
    
    if let fashionSize = fashionSize { properties[Constants.fashionSize] = fashionSize }
    if let fashionColor = fashionColor { properties[Constants.fashionColor] = fashionColor }
    if let barcode = barcode { properties[Constants.barcode] = barcode }
    
    validator.validate(email: email, phone: phone) { result in
    switch result {
        case .success(let validated):
            params.merge(validated) { _, new in new }
            self.handlePostRequest(
              path: Constants.subscribePath,
              params: params,
              completion: completion
            )
        case .failure(let error):
            self.handleValidationFailure(error: error, actionName: "subscribeForBackInStock", completion: completion)
        }
    }
  }
  
    func unsubscribeForBackInStock(
      itemIds: [String],
      email: String? = nil,
      phone: String? = nil,
      completion: @escaping (Result<Void, SdkError>) -> Void
    ) {
      guard var params = prepareBasicParams() else {
        completion(.failure(.custom(error: "unsubscribeForBackInStock: SDK is not initialized")))
        return
      }

      params[Constants.itemIds] = itemIds

      validator.validate(email: email, phone: phone) { result in
        switch result {
        case .success(let validated):
          params.merge(validated) { _, new in new }
            
          self.handlePostRequest(
            path: Constants.unsubscribePath,
            params: params,
            completion: completion
          )

        case .failure(let error):
          self.handleValidationFailure(error: error, actionName: "unsubscribeForBackInStock", completion: completion)
        }
      }
    }

  
    func unsubscribeForPriceDrop(
      itemIds: [String],
      currentPrice: Double,
      email: String? = nil,
      phone: String? = nil,
      completion: @escaping (Result<Void, SdkError>) -> Void
    ) {
      guard var params = prepareBasicParams() else {
        completion(.failure(.custom(error: "unsubscribeForPriceDrop: SDK is not initialized")))
        return
      }

      params[Constants.itemIds] = itemIds
      params[Constants.price] = currentPrice

      if let sdk = sdk {
        params[Constants.seance] = sdk.userSeance
        params[Constants.sid] = sdk.userSeance
        params[Constants.segment] = sdk.segment
      }

      validator.validate(email: email, phone: phone) { result in
        switch result {
        case .success(let validated):
          params.merge(validated) { _, new in new }
          self.handlePostRequest(
            path: Constants.unSubscribeForProductPricePath,
            params: params,
            completion: completion
          )
        case .failure(let error):
          self.handleValidationFailure(error: error, actionName: "unsubscribeForPriceDrop", completion: completion)
        }
      }
    }

  
  func manageSubscription(
    email: String? = nil,
    phone: String? = nil,
    userExternalId: String? = nil,
    userLoyaltyId: String? = nil,
    telegramId: String? = nil,
    emailBulk: Bool? = nil,
    emailChain: Bool? = nil,
    emailTransactional: Bool? = nil,
    smsBulk: Bool? = nil,
    smsChain: Bool? = nil,
    smsTransactional: Bool? = nil,
    webPushBulk: Bool? = nil,
    webPushChain: Bool? = nil,
    webPushTransactional: Bool? = nil,
    mobilePushBulk: Bool? = nil,
    mobilePushChain: Bool? = nil,
    mobilePushTransactional: Bool? = nil,
    completion: @escaping(Result<Void, SdkError>) -> Void
  ) {
    guard var params = prepareBasicParams() else {
      completion(.failure(.custom(error: "manageSubscription: SDK is not initialized")))
      return
    }
    
    validator.validate(email: email, phone: phone) { result in
        switch result {
            case .success(let validated):
              params.merge(validated) { _, new in new }
            case .failure(let error):
              self.handleValidationFailure(error: error, actionName: "manageSubscription", completion: completion)
                return 
        }
    }

    
    if let userExternalId          = userExternalId             { params[Constants.externalId]                 = userExternalId }
    if let userLoyaltyId           = userLoyaltyId              { params[Constants.loyaltyId]                  = userLoyaltyId }
    if let telegramId              = telegramId                 { params[Constants.telegramId]                 = telegramId }
    if let emailBulk               = emailBulk                  { params[Constants.emailBulk]                  = emailBulk }
    if let emailChain              = emailChain                 { params[Constants.emailChain]                 = emailChain }
    if let emailTransactional      = emailTransactional         { params[Constants.emailTransactional]         = emailTransactional }
    if let smsBulk                 = smsBulk                    { params[Constants.smsBulk]                    = smsBulk }
    if let smsChain                = smsChain                   { params[Constants.smsChain]                   = smsChain }
    if let smsTransactional        = smsTransactional           { params[Constants.smsTransactional]           = smsTransactional }
    if let webPushBulk             = webPushBulk                { params[Constants.webPushBulk]               = webPushBulk }
    if let webPushChain            = webPushChain               { params[Constants.webPushChain]              = webPushChain }
    if let webPushTransactional    = webPushTransactional       { params[Constants.webPushTransactional]      = webPushTransactional }
    if let mobilePushBulk          = mobilePushBulk             { params[Constants.mobilePushBulk]            = mobilePushBulk }
    if let mobilePushChain         = mobilePushChain            { params[Constants.mobilePushChain]           = mobilePushChain }
    if let mobilePushTransactional = mobilePushTransactional    { params[Constants.mobilePushTransactional]   = mobilePushTransactional }
      
    handlePostRequest(
      path: Constants.manageSubscriptionPath,
      params: params,
      completion: completion
    )

  }
    
    private func handleValidationFailure(
      error: ValidationError,
      actionName: String,
      completion: @escaping (Result<Void, SdkError>) -> Void
    ) {
        let message: String
        switch error {
        case .invalidEmail:
            message = "\(actionName): email is not valid"
        case .invalidPhone:
            message = "\(actionName): phone number is not valid"
        }

        completion(.failure(.custom(error: message)))
    }
}

