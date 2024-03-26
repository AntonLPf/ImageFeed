//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Антон Шишкин on 22.03.24.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    struct TestUserData {
        let login: String
        let password: String
        let nameAndLastName: String
        let userName: String
    }
    
    private let app = XCUIApplication()
    
    private let timeoutValue = 10.0
    
    // Set credentials  here
    let testUserData = TestUserData(
        login: "", // "someEmail@gmail.com"
        password: "",
        nameAndLastName: "", // "Ivan Petrov"
        userName: "") // "@ivanpetrov"
    
    override func setUpWithError() throws {
        guard
            !testUserData.login.isEmpty,
            !testUserData.password.isEmpty,
            !testUserData.nameAndLastName.isEmpty,
            !testUserData.userName.isEmpty
        else {
            preconditionFailure("No testing user data")
        }
        
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: timeoutValue))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: timeoutValue))
        
        loginTextField.tap()
        loginTextField.typeText(testUserData.login)
        dismissKeyboardIfPresent(webView: webView)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: timeoutValue))
        passwordTextField.tap()
        sleep(2)

        passwordTextField.typeText(testUserData.password)
        sleep(2)
        dismissKeyboardIfPresent(webView: webView)
        
        webView.buttons["Login"].tap()
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: timeoutValue))
    }
    
    func testFeed() {
        sleep(5)
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button off"].tap()
        
        sleep(4)
        
        cellToLike.buttons["like button on"].tap()
        
        sleep(4)
        
        cellToLike.tap()
        
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 2, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[testUserData.nameAndLastName].exists)
        XCTAssertTrue(app.staticTexts[testUserData.userName].exists)
        
        app.buttons["logout button"].tap()
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
    
    private func dismissKeyboardIfPresent(webView: XCUIElement) {
        if app.keyboards.element(boundBy: 0).exists {
            if app.toolbars.buttons["Done"].exists {
                app.toolbars.buttons["Done"].tap()
            } else {
                webView.swipeUp()
            }
        }
    }
    
}
