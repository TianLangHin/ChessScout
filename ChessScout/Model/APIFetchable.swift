//
//  APIFetchable.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

protocol APIFetchable {
    associatedtype Parameters
    associatedtype FetchedData
    
    func fetch(_ parameters: Parameters) -> FetchedData?
}
