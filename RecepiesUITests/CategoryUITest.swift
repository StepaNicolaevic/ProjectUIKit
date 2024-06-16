//
//  CategoryUITest.swift
//  RecepiesUITests
//


import XCTest

// swiftlint: disable all
final class CategoryUITest: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        let currentLogin = "1@123"
        let currentPassword = "123456"

        let enterEmailAddressTextField = app.textFields["Enter Email Address"]
        enterEmailAddressTextField.tap()
        enterEmailAddressTextField.typeText(currentLogin)

        let enterPasswordSecureTextField = app.secureTextFields["Enter Password"]
        enterPasswordSecureTextField.tap()
        enterPasswordSecureTextField.typeText(currentPassword)

        app.buttons["Login"].tap()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testTabCell() {
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: "Chicken").element.tap()

        let titleRecipe = app.navigationBars["Recepies.CategoryView"].staticTexts["Chicken"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: titleRecipe)
        waitForExpectations(timeout: 2)
    }

    func testScrollCollectionView() {
        let horizontalScrollBar1PageCollectionView = app.collectionViews.containing(.other, identifier: "Horizontal scroll bar, 1 page").element
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeDown()
    }

    func testTabBar() {
        let tabBar = XCUIApplication().tabBars["Tab Bar"]
        tabBar.buttons["Favorites"].tap()

        let favoritesStaticText = XCUIApplication().staticTexts["Favorites"]
        XCTAssertTrue(favoritesStaticText.exists)

        tabBar.buttons["Recipes"].tap()
        let recipesStaticText = XCUIApplication().navigationBars["Recepies.RecipesView"].staticTexts["Recipes"]
        XCTAssertTrue(recipesStaticText.exists)
    }
}

// swiftlint: enable all
