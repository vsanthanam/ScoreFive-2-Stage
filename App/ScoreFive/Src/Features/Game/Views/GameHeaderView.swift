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

    // MARK: - Initializers

    override init() {
        stack = .init()
        super.init()
        setUp()
    }

    // MARK: - API

    func apply(names: [String]) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        names.forEach { name in
            let view = IndexView()
            view.title = name
            stack.addArrangedSubview(view)
        }
    }

    // MARK: - Private

    private let stack: UIStackView

    private func setUp() {
        backgroundColor = .backgroundPrimary
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
                .inset(54.0)
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
            backgroundColor = .backgroundPrimary
            label.font = .systemFont(ofSize: 17.0, weight: .bold)
            label.textAlignment = .center
            label.textColor = .contentPrimary
            addSubview(label)
            label.snp.makeConstraints { make in
                make
                    .center
                    .equalToSuperview()
                make
                    .top
                    .bottom
                    .equalToSuperview()
                    .inset(18.0)
            }
        }
    }
}
