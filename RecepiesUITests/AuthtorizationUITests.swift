// AuthtorizationUITests.swift


import XCTest

// swiftlint: disable all
final class AuthtorizationUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Тест раздела Авторизации
    func testAuthtorization() {
        let app = XCUIApplication()
        app.launch()
        /// Проверить наличие текста  в заголовке
        checkStatic(textID: "Login")
        /// Проверить наличие текста логина
        checkStatic(textID: "Email Adress")
        /// Проверить наличие текста пароль
        checkStatic(textID: "Password")
    }

    func checkStatic(textID: String) {
        guard XCUIApplication().staticTexts[textID].exists else {
            XCTFail("Нет текста \(textID)")
            return
        }
    }

    func testAuftorizationSuccess() {
        let currentLogin = "1@123"
        let currentPassword = "123456"

        let app = XCUIApplication()
        app.launch()
        let enterEmailAddressTextField = app.textFields["Enter Email Address"]
        enterEmailAddressTextField.tap()
        enterEmailAddressTextField.typeText(currentLogin)

        let enterPasswordSecureTextField = app.secureTextFields["Enter Password"]
        enterPasswordSecureTextField.tap()
        enterPasswordSecureTextField.typeText(currentPassword)

        app.buttons["Login"].tap()

        let collectionView = app.collectionViews/*@START_MENU_TOKEN@*/ .cells.staticTexts["Chicken"]/*[[".cells.staticTexts[\"Chicken\"]",".staticTexts[\"Chicken\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: collectionView)
        waitForExpectations(timeout: 8)
    }

    func testAuftorizationFailure() {
        let currentLogin = "1@123"
        let currentPassword = "1234567"

        let app = XCUIApplication()
        app.launch()

        let enterEmailAddressTextField = app.textFields["Enter Email Address"]
        enterEmailAddressTextField.tap()
        enterEmailAddressTextField.typeText(currentLogin)

        let enterPasswordSecureTextField = app.secureTextFields["Enter Password"]
        enterPasswordSecureTextField.tap()
        enterPasswordSecureTextField.typeText(currentPassword)

        app.buttons["Login"].tap()

        let errorView = app.staticTexts["Please check the accuracy of the entered credentials."]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: errorView)
        waitForExpectations(timeout: 3)
    }

    func testAuftorizationInvalidEmail() {
        let currentLogin = "1123"
        let app = XCUIApplication()
        app.launch()

        let enterEmailAddressTextField = app.textFields["Enter Email Address"]
        enterEmailAddressTextField.tap()
        enterEmailAddressTextField.typeText(currentLogin)
        app.buttons["Login"].tap()
        let invalidEmailText = app.staticTexts["Incorrect format"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: invalidEmailText)
        waitForExpectations(timeout: 3)
    }

    func testAuftorizationInvalidPassword() {
        let currentPassword = "1"

        let app = XCUIApplication()
        app.launch()

        let enterPasswordSecureTextField = app.secureTextFields["Enter Password"]
        enterPasswordSecureTextField.tap()
        enterPasswordSecureTextField.typeText(currentPassword)

        app.buttons["Login"].tap()

        let invalidPasswordText = app.staticTexts["You entered the wrong password"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: invalidPasswordText)
        waitForExpectations(timeout: 3)
    }

    func testButtonSecurityTextPassword() {
        let app = XCUIApplication()
        app.launch()
    }
}

// swiftlint: enable all
