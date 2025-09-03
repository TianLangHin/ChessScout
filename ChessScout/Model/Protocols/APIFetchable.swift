//
//  APIFetchable.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

/// This protocol is to be conformed to by any struct or class that has an asynchronous functionality
/// that fetches some kind of data, with each query needing some setting or parameters.
///
/// Since different APIs and fetchers will need different structure for query parameters
/// and will return different data structures, `Parameters` and `FetchedData` are generic associated types
/// that are specified each time for the particular concrete implementation.
protocol APIFetchable<Parameters, FetchedData> {
    associatedtype Parameters
    associatedtype FetchedData

    /// API calls may fail, so the function signature accounts for this by allowing the returning of a `nil`.
    func fetch(_ parameters: Parameters) async -> FetchedData?
}
