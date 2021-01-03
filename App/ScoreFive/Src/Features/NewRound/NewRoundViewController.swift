//
//  NewRoundViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import FiveUI
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol NewRoundViewControllable: ViewControllable {}

/// @mockable
protocol NewRoundPresentableListener: AnyObject {}

final class NewRoundViewController: ScopeViewController, NewRoundPresentable, NewRoundViewControllable {
    
    // MARK: - Initializers
    
    override init(_ viewBuilder: @escaping () -> ScopeView) {
        super.init(viewBuilder)
        isModalInPresentation = true
        modalPresentationStyle = .fullScreen
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - NewRoundPresentable
    
    weak var listener: NewRoundPresentableListener?
    
    // MARK: - Private
    
    private let topInset = BaseView()
    private let headerView = HeaderView()
    
    private func setUp() {
        specializedView.backgroundColor = .backgroundPrimary
        
        topInset.backgroundColor = .backgroundInversePrimary
        specializedView.addSubview(topInset)
        
        headerView.title = "Add Scores"
        specializedView.addSubview(headerView)
        
        topInset.snp.makeConstraints { make in
            make
                .top
                .leading
                .trailing
                .equalToSuperview()
            make
                .bottom
                .equalTo(specializedView.safeAreaLayoutGuide.snp.top)
        }
        
        headerView.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .equalToSuperview()
            make
                .top
                .equalTo(specializedView.safeAreaLayoutGuide)
        }
    }
}
