//
//  ProductsAPI.swift
//  PersonaClick
//
//  The `products` namespace of the contract (`sdk/contract/products.md`).
//

import Foundation

/**
 The shop's products: a product's card, the catalog by filters, the counters of a product and the page of
 a category. Each method is one request; the answer comes as the contract's models (`PersonaClick.Product` and
 the rest).

 For the Flutter and React Native bridges, as every namespace but `tracking`: `@_spi(Bridge) import
 PersonaClick` and a shop started with `PersonaClick.initializeBridge`. On the old core every method ends as
 `notInitialized` and sends nothing.

 Every `completion` is called once, on the main thread, with the value or the error: `notInitialized` on
 the old core or after `release()`, `shopBlocked`, `invalidArgument` for an argument refused before
 anything is sent, `network`, `timeout`, `http(code:serverCode:)`, `decoding`, `cancelled` for a call
 `release()` ended. The `async` forms throw the same `PersonaClick.SdkError`, and cancelling the task ends the
 call as `cancelled`. Nothing is repeated: the app decides.
 */
@_spi(Bridge)
public protocol ProductsAPI {

    /// The card of a product (`GET products/get`): `nil` for an id the server does not know — it
    /// answers that with an empty object. `itemId` is the shop's id of the product, not empty.
    func getInfo(itemId: String, completion: @escaping (Result<PersonaClick.Product?, PersonaClick.SdkError>) -> Void)

    func getInfo(itemId: String) async throws -> PersonaClick.Product?

    /// The catalog by filters, sorted and by pages (`GET products`): a listing without a query.
    func getList(_ request: PersonaClick.ProductsListRequest, completion: @escaping (Result<PersonaClick.ProductsListResponse, PersonaClick.SdkError>) -> Void)

    func getList(_ request: PersonaClick.ProductsListRequest) async throws -> PersonaClick.ProductsListResponse

    /// How many times a product was viewed, put into a cart and bought today and in the last 30 minutes,
    /// and how many subscriptions to its price and stock it has (`GET products/counters`).
    func getCounters(itemId: String, completion: @escaping (Result<ProductCountersResponse, PersonaClick.SdkError>) -> Void)

    func getCounters(itemId: String) async throws -> ProductCountersResponse

    /// The page of a category: its products, facets, prices and sorting. The listing of `getList` with
    /// the category as its only `categoryIds`, which the server answers as it answers `category/{id}`.
    func getCategory(
        categoryId: String,
        request: PersonaClick.CategoryRequest,
        completion: @escaping (Result<PersonaClick.CategoryResponse, PersonaClick.SdkError>) -> Void
    )

    func getCategory(categoryId: String, request: PersonaClick.CategoryRequest) async throws -> PersonaClick.CategoryResponse
}

/// The requests by default: protocol requirements cannot carry them.
@_spi(Bridge)
extension ProductsAPI {

    /// The first page of the whole catalog.
    public func getList(completion: @escaping (Result<PersonaClick.ProductsListResponse, PersonaClick.SdkError>) -> Void) {
        getList(PersonaClick.ProductsListRequest(), completion: completion)
    }

    /// The first page of the whole catalog.
    public func getList() async throws -> PersonaClick.ProductsListResponse {
        try await getList(PersonaClick.ProductsListRequest())
    }

    /// The first page of the category.
    public func getCategory(categoryId: String, completion: @escaping (Result<PersonaClick.CategoryResponse, PersonaClick.SdkError>) -> Void) {
        getCategory(categoryId: categoryId, request: PersonaClick.CategoryRequest(), completion: completion)
    }

    /// The first page of the category.
    public func getCategory(categoryId: String) async throws -> PersonaClick.CategoryResponse {
        try await getCategory(categoryId: categoryId, request: PersonaClick.CategoryRequest())
    }
}

@_spi(Bridge)
extension PersonalizationSDK {

    /// The shop's products (`ProductsAPI`): on the new core only.
    public var products: ProductsAPI {
        ProductsAPIImpl(requests: NamespaceRequests(self))
    }
}
