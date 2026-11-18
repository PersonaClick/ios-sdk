//
//  ProductsAPIImpl.swift
//  PersonaClick
//

import Foundation

struct ProductsAPIImpl: ProductsAPI {

    let requests: NamespaceRequests

    func getInfo(itemId: String, completion: @escaping (Result<PersonaClick.Product?, PersonaClick.SdkError>) -> Void) {
        requests.call("products.getInfo", completion: completion) { try Self.infoRequest(itemId: itemId) }
    }

    func getInfo(itemId: String) async throws -> PersonaClick.Product? {
        try await requests.value("products.getInfo") { try Self.infoRequest(itemId: itemId) }
    }

    func getList(_ request: PersonaClick.ProductsListRequest, completion: @escaping (Result<PersonaClick.ProductsListResponse, PersonaClick.SdkError>) -> Void) {
        requests.call("products.getList", completion: completion) { try Self.listRequest(request) }
    }

    func getList(_ request: PersonaClick.ProductsListRequest) async throws -> PersonaClick.ProductsListResponse {
        try await requests.value("products.getList") { try Self.listRequest(request) }
    }

    func getCounters(itemId: String, completion: @escaping (Result<ProductCountersResponse, PersonaClick.SdkError>) -> Void) {
        requests.call("products.getCounters", completion: completion) { try Self.countersRequest(itemId: itemId) }
    }

    func getCounters(itemId: String) async throws -> ProductCountersResponse {
        try await requests.value("products.getCounters") { try Self.countersRequest(itemId: itemId) }
    }

    func getCategory(
        categoryId: String,
        request: PersonaClick.CategoryRequest,
        completion: @escaping (Result<PersonaClick.CategoryResponse, PersonaClick.SdkError>) -> Void
    ) {
        requests.call("products.getCategory", completion: completion) { try Self.categoryRequest(categoryId: categoryId, request) }
    }

    func getCategory(categoryId: String, request: PersonaClick.CategoryRequest) async throws -> PersonaClick.CategoryResponse {
        try await requests.value("products.getCategory") { try Self.categoryRequest(categoryId: categoryId, request) }
    }

    // MARK: - Requests

    /// `GET products/get?item_id=`. The server answers an id it does not know with `{}`: no product. An
    /// answer with something else but neither `uniqid` nor `id` is `decoding`.
    static func infoRequest(itemId: String) throws -> ApiRequest<PersonaClick.Product?> {
        let id = try CatalogQuery.identifier(itemId, "itemId")
        return ApiRequest(method: .get, path: "products/get", query: ["item_id": id]) { body in
            guard !body.isEmpty else { return nil }
            return try ProductCard.read(body)
        }
    }

    /// `GET products` with the request's filters; `extended` is not sent, the server always gives the
    /// products whole.
    static func listRequest(_ request: PersonaClick.ProductsListRequest) throws -> ApiRequest<PersonaClick.ProductsListResponse> {
        try CatalogQuery.positive(request.limit, "limit")
        try CatalogQuery.positive(request.page, "page")
        try CatalogQuery.prices(request.priceMin, request.priceMax)
        try CatalogQuery.listingSort(request.sortBy)
        var query = CatalogQuery()
        query.set("categories", list: request.categoryIds)
        query.set("brands", list: request.brands)
        query.set("merchants", list: request.merchants)
        query.set("locations", list: request.locations)
        query.set("price_min", number: request.priceMin)
        query.set("price_max", number: request.priceMax)
        try query.set("filters", filters: request.filters)
        query.set("sort_by", request.sortBy?.rawValue)
        query.set("sort_dir", request.sortDir?.rawValue)
        query.set("limit", int: request.limit)
        query.set("page", int: request.page)
        return ApiRequest(method: .get, path: "products", query: query.fields) { body in
            try Readable<PersonaClick.ProductsListResponse>.read(body)
        }
    }

    /// `GET products/counters?item=`. An answer without a body or without a counter has none of it.
    static func countersRequest(itemId: String) throws -> ApiRequest<ProductCountersResponse> {
        let id = try CatalogQuery.identifier(itemId, "itemId")
        return ApiRequest(method: .get, path: "products/counters", query: ["item": id]) { body in
            try Readable<ProductCountersResponse>.read(body.isEmpty ? Data("{}".utf8) : body)
        }
    }

    /// The listing of `listRequest` with the category alone in `categories`: `GET category/{id}` is
    /// that same listing on the server, and it is to be removed there (question В31).
    static func categoryRequest(categoryId: String, _ request: PersonaClick.CategoryRequest) throws -> ApiRequest<PersonaClick.CategoryResponse> {
        let id = try CatalogQuery.identifier(categoryId, "categoryId")
        let list = try listRequest(PersonaClick.ProductsListRequest(
            categoryIds: [id],
            brands: request.brands,
            locations: request.locations,
            priceMin: request.priceMin,
            priceMax: request.priceMax,
            filters: request.filters,
            sortBy: request.sortBy,
            sortDir: request.sortDir,
            limit: request.limit,
            page: request.page
        ))
        return ApiRequest(method: list.method, path: list.path, query: list.query) { body in
            PersonaClick.CategoryResponse(try list.decode(body))
        }
    }
}

/// The answer of `products/get`: the product itself, its id `uniqid`; `{}` is no product. Its `params` is
/// an object of name → values, read in the answer's order (`AnswerKeyOrder`).
private struct ProductCard: Decodable {
    let product: PersonaClick.Product?

    init(from decoder: Decoder) throws {
        let answer = try decoder.container(keyedBy: AnswerKey.self)
        let order = Self.paramOrder.flatMap { decoder.userInfo[$0] as? [String] } ?? []
        product = answer.allKeys.isEmpty ? nil : try PersonaClick.Product(answer: answer, preferringUniqid: true, paramOrder: order)
    }

    /// The product of `body`, or `decoding`.
    static func read(_ body: Data) throws -> PersonaClick.Product? {
        let decoder = JSONDecoder()
        if let key = paramOrder {
            decoder.userInfo[key] = AnswerKeyOrder.keys(ofObjectAt: "params", in: body) ?? []
        }
        return try decoder.decode(ProductCard.self, from: body).product
    }

    /// Where `read` hands the decoder the names of `params` in the answer's order.
    private static let paramOrder = CodingUserInfoKey(rawValue: "PersonaClick.ProductCard.paramOrder")
}
