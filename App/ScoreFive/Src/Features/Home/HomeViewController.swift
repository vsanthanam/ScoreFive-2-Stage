//
//  HomeViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import FiveUI
import Foundation
import ScoreKeeping
import ShortRibs
import UIKit

/// @mockable
protocol HomeViewControllable: ViewControllable {}

/// @mockable
protocol HomePresentableListener: AnyObject {
    func didTapNewGame()
    func didTapResumeLastGame()
}

final class HomeViewController: ScopeViewController, HomePresentable, HomeViewControllable {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - HomePresentable

    weak var listener: HomePresentableListener?

    func showNewGame(_ viewController: ViewControllable) {
        confineTo(viewEvents: [.viewDidAppear], once: true) {
            if let current = self.newGameViewController {
                current.uiviewController.dismiss(animated: true) { [weak self] in
                    self?.newGameViewController = nil
                    self?.showNewGame(viewController)
                }
            } else {
                self.present(viewController.uiviewController, animated: true) { [weak self] in
                    self?.newGameViewController = viewController
                }
            }
        }
    }

    func closeNewGame() {
        newGameViewController?.uiviewController.dismiss(animated: true, completion: nil)
    }

    func showResumeButton() {
        confineTo(viewEvents: [.viewDidLoad], once: true) { [weak self] in
            guard let self = self else { return }
            if self.resumeGameButton != nil {
                self.buttonStackView.removeArrangedSubview(self.buttonStackView)
                self.resumeGameButton = nil
            }
            let button = HomeButton(title: "Resume Last Game")
            button.addTarget(self, action: #selector(self.didTapResume), for: .touchUpInside)
            self.buttonStackView.addArrangedSubview(button)
            self.resumeGameButton = button
        }
    }

    func hideResumeButton() {
        confineTo(viewEvents: [.viewDidLoad], once: true) { [weak self] in
            guard let self = self else { return }
            self.buttonStackView.removeArrangedSubview(self.buttonStackView)
            self.resumeGameButton = nil
        }
    }

    // MARK: - Private

    private let layoutGuide = UILayoutGuide()
    private let buttonStackView = UIStackView()

    private var resumeGameButton: HomeButton?

    private var newGameViewController: ViewControllable?

    private func setUp() {
        specializedView.backgroundColor = .backgroundPrimary
        specializedView.addLayoutGuide(layoutGuide)
        let image = UIImage(named: "CardIcon")
        let imageView = UIImageView()
        imageView.tintColor = .contentAccentPrimary
        imageView.image = image

        let newGameButton = HomeButton(title: "New Game")

        buttonStackView.axis = .vertical
        buttonStackView.spacing = 12.0

        specializedView.addSubview(imageView)
        specializedView.addSubview(buttonStackView)

        layoutGuide.snp.makeConstraints { make in
            make
                .center
                .equalToSuperview()
            make
                .leading
                .trailing
                .equalTo(specializedView.safeAreaLayoutGuide)
                .inset(16.0)
        }

        imageView.snp.makeConstraints { make in
            make
                .top
                .equalTo(layoutGuide)
            make.centerX.equalTo(layoutGuide)
            make
                .size
                .equalTo(CGSize(width: 128.0,
                                height: 128.0))
        }

        buttonStackView.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .bottom
                .equalTo(layoutGuide)
            make
                .top
                .equalTo(imageView.snp.bottom)
                .offset(24.0)
        }

        newGameButton.title = "New Game"
        newGameButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        newGameButton.addTarget(self, action: #selector(tapAdd), for: .touchUpInside)
        buttonStackView.insertArrangedSubview(newGameButton, at: 0)
    }

    @objc
    private func tapAdd() {
        listener?.didTapNewGame()
    }

    @objc func didTapResume() {
        listener?.didTapResumeLastGame()
    }
}

private final class HomeButton: TappableControl {

    init(title: String? = nil) {
        super.init()
        setUp()
        self.title = title
    }

    // MARK: - API

    var title: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }

    // MARK: - UIControl

    override var isHighlighted: Bool {
        didSet {
            updateColors()
        }
    }

    // MARK: - Private

    private let label = UILabel()

    private func setUp() {
        layer.cornerRadius = 12.0
        label.textColor = .contentOnColorPrimary
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        addSubview(label)
        label.snp.makeConstraints { make in
            make
                .center
                .equalToSuperview()
            make
                .top
                .bottom
                .equalToSuperview()
                .inset(16.0)
        }
        updateColors()
    }

    private func updateColors() {
        if isHighlighted {
            backgroundColor = .contentAccentSecondary
        } else {
            backgroundColor = .contentAccentPrimary
        }
    }
}
