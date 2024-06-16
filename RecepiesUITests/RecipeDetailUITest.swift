//
//  RecipeDetailUITest.swift
//  RecepiesUITests
//
//  Created by Степан Пахолков on 03.04.2024.
//

import XCTest

// swiftlint: disable all
final class RecipeDetailUITest: XCTestCase {
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
        app.tables/*@START_MENU_TOKEN@*/ .staticTexts["Chicken Paprikash"]/*[[".cells.staticTexts[\"Chicken Paprikash\"]",".staticTexts[\"Chicken Paprikash\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
    }

    override func tearDownWithError() throws {}

    func testTapBackBotton() {
        let app = XCUIApplication()

        app.navigationBars["Recepies.DetailView"].buttons["arrowLeft"].tap()

        let resultTap = app.navigationBars["Recepies.CategoryView"].staticTexts["Chicken"]
        XCTAssertTrue(resultTap.exists)
    }

    func testScrollTableView() {
        let cookingTime0MinStaticText = XCUIApplication().tables/*@START_MENU_TOKEN@*/ .staticTexts["Cooking time 0 min"]/*[[".cells.staticTexts[\"Cooking time 0 min\"]",".staticTexts[\"Cooking time 0 min\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        cookingTime0MinStaticText.swipeUp()
        cookingTime0MinStaticText.swipeDown()
    }

    func testTapShareButton() {
        let recepiesDetailviewNavigationBar = XCUIApplication().navigationBars["Recepies.DetailView"]
        recepiesDetailviewNavigationBar.buttons["send"].tap()
    }

    func testTapFavoritesButton() {
        let recepiesDetailviewNavigationBar = XCUIApplication().navigationBars["Recepies.DetailView"]
        recepiesDetailviewNavigationBar.buttons["favorites"].tap()
        recepiesDetailviewNavigationBar.buttons["favoritesHig"].tap()
    }
}

// swiftlint: enable all
