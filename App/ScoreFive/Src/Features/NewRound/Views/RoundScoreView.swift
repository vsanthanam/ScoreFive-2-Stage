//
//  RoundScoreView.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 2/13/21.
//

import Foundation
import UIKit
import FiveUI
import SnapKit

final class RoundScoreView: BaseView {
    
    override init() {
        super.init()
        setUp()
    }
    
    private let textfield = UITextField()
    
    private func setUp() {
        backgroundColor = .backgroundPrimary
        addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make
                .center
                .equalToSuperview()
            make
                .leading
                .trailing
                .equalToSuperview()
                .inset(16.0)
        }
    }
}
