//
//  MockRequestCreator.swift
//  Recepies


import Foundation

class MockRequestCreator: RequestCreatorProtocol {
    private enum Constants {
        static let sheme = "https"
        static let host = "api.edamam.com"
    }

    func createCategoryURLRequest(type _: CategoryType, text _: String) -> URLRequest? {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return nil }
        return URLRequest(url: url)
    }

    func createRecipeURLRequest(uri _: String) -> URLRequest? {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return nil }
        return URLRequest(url: url)
    }
}
