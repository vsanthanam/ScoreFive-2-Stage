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
        backgroundColor = .backgroundInversePrimary
        label.font = .systemFont(ofSize: 27.0, weight: .medium)
        label.textAlignment = .natural
        label.textColor = .contentInversePrimary
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
    }
    
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 72.0)
    }
}
