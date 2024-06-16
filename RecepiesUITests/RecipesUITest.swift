//
//  RecipesUITest.swift
//  RecepiesUITests
//
//  Created by Степан Пахолков on 03.04.2024.
//

import XCTest

// swiftlint: disable all
final class RecipesUITest: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launch()
        let currentLogin = "1@123"
        let currentPassword = "123456"

        app.launch()
        let enterEmailAddressTextField = app.textFields["Enter Email Address"]
        enterEmailAddressTextField.tap()
        enterEmailAddressTextField.typeText(currentLogin)

        let enterPasswordSecureTextField = app.secureTextFields["Enter Password"]
        enterPasswordSecureTextField.tap()
        enterPasswordSecureTextField.typeText(currentPassword)

        app.buttons["Login"].tap()
        app.collectionViews/*@START_MENU_TOKEN@*/ .staticTexts["Chicken"]/*[[".cells.staticTexts[\"Chicken\"]",".staticTexts[\"Chicken\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTapBackBotton() {
        let app = XCUIApplication()

        app.navigationBars["Recepies.CategoryView"].buttons["arrowLeft"].tap()

        let resultTapButton = app.navigationBars["Recepies.RecipesView"].staticTexts["Recipes"]
        XCTAssertTrue(resultTapButton.exists)
    }

    func testSwipeTableView() {
        let tablesQuery = XCUIApplication().tables
        tablesQuery/*@START_MENU_TOKEN@*/ .cells.containing(.staticText, identifier: "2253 kkal")/*[[".cells.containing(.staticText, identifier:\"Teriyaki Chicken\")",".cells.containing(.staticText, identifier:\"2253 kkal\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .children(matching: .other).element.swipeUp()
        tablesQuery.element.swipeDown()
    }

    func testNotDataSearch() {
        let searchText = "Awd"
        let app = XCUIApplication()
        let searchRecipesSearchField = app.searchFields["Search recipes"]
        searchRecipesSearchField.tap()
        searchRecipesSearchField.typeText(searchText)

        let resultSearch = app.staticTexts["Start typing text"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: resultSearch)
        waitForExpectations(timeout: 2)
    }

    func testPullRefresh() {}

    func testTapSortingCaloriesButton() {
        let app = XCUIApplication()
        let caloriesStaticText = app.buttons["    Calories   "]
        caloriesStaticText.tap()
        caloriesStaticText.tap()
        caloriesStaticText.tap()
    }

    func testTapSortingTimeButton() {
        let timeStaticText = XCUIApplication().buttons["    Time   "]
        timeStaticText.tap()
        timeStaticText.tap()
        timeStaticText.tap()
    }

    func testTapCell() {
        let chickenPaprikashStaticText = XCUIApplication().tables/*@START_MENU_TOKEN@*/ .staticTexts["Chicken Paprikash"]/*[[".cells.staticTexts[\"Chicken Paprikash\"]",".staticTexts[\"Chicken Paprikash\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        chickenPaprikashStaticText.tap()
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: chickenPaprikashStaticText)
        waitForExpectations(timeout: 2)
    }
}

// swiftlint: enable all
