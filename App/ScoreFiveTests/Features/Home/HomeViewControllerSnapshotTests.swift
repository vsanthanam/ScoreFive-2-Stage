//
//  HomeButtonSnapshotTests.swift
//  ScoreFiveTests
//
//  Created by Varun Santhanam on 2/6/21.
//

@testable import ScoreFive
import Foundation
import FBSnapshotTestCase

final class HomeViewControllerSnapshotTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    func test_default_homeScreen() {
        let viewController = HomeViewController()
        viewController.loadView()
        viewController.viewDidLoad()
        viewController.hideResumeButton()
        FBSnapshotVerifyViewController(viewController)
    }
    
    func test_resumeLast_homeScreen() {
        let viewController = HomeViewController()
        viewController.loadView()
        viewController.viewDidLoad()
        viewController.showResumeButton()
        FBSnapshotVerifyViewController(viewController)
    }
}
