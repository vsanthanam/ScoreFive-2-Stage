//
//  GameHeaderView.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 1/1/21.
//

import FiveUI
import Foundation
import UIKit

final class GameHeaderView: BaseView {
    
    override init() {
        stack = .init()
        super.init()
        setUp()
    }
    
    func apply(names: [String]) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        names.forEach { name in
            let view = IndexView()
            view.title = name
            stack.addArrangedSubview(view)
        }
    }
    
    private let stack: UIStackView
    
    private func setUp() {
        backgroundColor = .backgroundInversePrimary
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make
                .top
                .bottom
                .trailing
                .equalToSuperview()
            make
                .leading
                .equalToSuperview()
                .inset(44.0)
        }
    }
    
    private class IndexView: BaseView {
        
        override init() {
            super.init()
            setUp()
        }
        
        var title: String? {
            get { label.text }
            set { label.text = newValue }
        }
        
        private let label = UILabel()
        
        private func setUp() {
            backgroundColor = .backgroundInversePrimary
            label.textAlignment = .center
            label.textColor = .contentInversePrimary
            addSubview(label)
            label.snp.makeConstraints { make in
                make
                    .center
                    .equalToSuperview()
                make
                    .top
                    .bottom
                    .equalToSuperview()
                    .inset(12.0)
            }
        }
    }
}
