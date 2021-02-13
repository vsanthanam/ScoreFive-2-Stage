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
protocol NewRoundPresentableListener: AnyObject {
    func didTapClose()
}

final class NewRoundViewController: ScopeViewController, NewRoundPresentable, NewRoundViewControllable, UINavigationBarDelegate {

    // MARK: - Initializers

    override init(_ viewBuilder: @escaping () -> ScopeView) {
        super.init(viewBuilder)
        isModalInPresentation = true
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    // MARK: - UINavigationBarDelegate

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }

    // MARK: - NewRoundPresentable

    weak var listener: NewRoundPresentableListener?

    // MARK: - Private

    private let header = UINavigationBar()

    private func setUp() {
        specializedView.backgroundColor = .backgroundPrimary

        let navigationItem = UINavigationItem(title: "Add Scores")
        navigationItem.largeTitleDisplayMode = .always

        let closeItem = UIBarButtonItem(barButtonSystemItem: .close,
                                        target: self,
                                        action: #selector(close))
        navigationItem.leftBarButtonItem = closeItem

        header.setItems([navigationItem], animated: false)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .backgroundPrimary

        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 10 // This is added to the default margin
        appearance.largeTitleTextAttributes = [.paragraphStyle: style]

        header.scrollEdgeAppearance = appearance
        header.delegate = self
        header.prefersLargeTitles = true
        specializedView.addSubview(header)

        header.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .equalToSuperview()
            make
                .top
                .equalTo(specializedView.safeAreaLayoutGuide)
        }

        let roundView = RoundScoreView()

    }

    @objc
    private func close() {
        listener?.didTapClose()
    }
}
