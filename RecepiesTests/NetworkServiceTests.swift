//
//  NetworkServiceTests.swift
//  RecepiesTests


@testable import Recepies
import XCTest

final class NetworkServiceTests: XCTestCase {
    private enum Constants {
        static let urlImage = "https://www.edamam.com/assets/img/logo.png"
        static let urlImageFail = "www"
        static let recipeNameDetail = "Chicken Paprikash"
        static let urlRecipeDetail = "http://www.edamam.com/ontologies/edamam.owl#recipe_8275bb28647abcedef0baaf2dcf34f8b"
    }

    var networkService: NetworkServiceProtocol!
    var requestCreator: RequestCreatorProtocol!
    var networkCreaterFail: RequestCreatorProtocol!
    var networkServicefail: NetworkServiceProtocol!
    var loadImageService: LoadImageServiceProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()
        requestCreator = RequestCreator()
        networkCreaterFail = MockRequestCreator()
        networkServicefail = NetworkService(requestCreator: networkCreaterFail)
        networkService = NetworkService(requestCreator: requestCreator)
        loadImageService = NetworkService(requestCreator: requestCreator)
    }

    override func tearDownWithError() throws {
        networkService = nil
        requestCreator = nil
        networkCreaterFail = nil
        networkServicefail = nil
        loadImageService = nil
        try super.tearDownWithError()
    }

    func testRecipesCategorySuccess() {
        let expectation = XCTestExpectation()
        networkService.getRecipes(type: CategoryType.meat, text: "") { result in

            switch result {
            case .failure:
                expectation.fulfill()
            case let .success(recipes):
                XCTAssertEqual(recipes.count, 20)
                print(recipes.count)
                expectation.fulfill()
            }
        }
        wait(for: [expectation])
    }

    func testRecipesCategoryFail() {
        let expectation = XCTestExpectation()
        networkServicefail.getRecipes(type: .meat, text: "") { result in

            switch result {
            case let .failure(error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success:
                expectation.fulfill()
            }
        }
        wait(for: [expectation])
    }

    func testRecipesDetailSuccess() {
        let expectation = XCTestExpectation()
        networkService.getDetailedRecipe(url: Constants.urlRecipeDetail) { result in

            switch result {
            case .failure:
                expectation.fulfill()
            case let .success(recipes):
                XCTAssertEqual(recipes.name, Constants.recipeNameDetail)
                expectation.fulfill()
            }
        }
        wait(for: [expectation])
    }

    func testRecipesDetailFail() {
        let expectation = XCTestExpectation()
        networkService.getDetailedRecipe(url: "") { result in

            switch result {
            case let .failure(error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success:
                expectation.fulfill()
            }
        }
        wait(for: [expectation])
    }

    func testLoadImageSuccess() {
        let expectation = XCTestExpectation()
        loadImageService.loadImage(by: Constants.urlImage) { result in
            switch result {
            case let .success(image):
                XCTAssertNotNil(image)
                expectation.fulfill()
            case .failure:
                expectation.fulfill()
            }
        }
        wait(for: [expectation])
    }

    func testLoadImageError() {
        let expectation = XCTestExpectation()
        loadImageService.loadImage(by: Constants.urlImageFail) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation])
    }
}
