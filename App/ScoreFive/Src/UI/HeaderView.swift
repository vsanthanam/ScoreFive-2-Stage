//
//  HeaderView.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/30/20.
//

import Foundation
import FiveUI
import UIKit

class HeaderView: BaseView {
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        backgroundColor = .backgroundPrimary
        setUp()
    }
    
    // MARK: - API
    
    var title: String? {
        get { label.text }
        set { label.text = newValue}
    }
    
    // MARK: - Private
    
    private let label = UILabel()
    
    private func setUp() {
        label.font = .systemFont(ofSize: 27.0, weight: .regular)
        label.textAlignment = .natural
        addSubview(label)
        label.snp.makeConstraints { make in
            make
                .leading
                .equalToSuperview()
                .inset(16.0)
            make
                .bottom
                .equalToSuperview()
                .inset(8.0)
        }
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.shadowColor.cgColor
        layer.shadowOffset = .init(width: 0.0, height: 1.0)
        layer.shadowRadius = 4.0
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 112.0)
    }
}
