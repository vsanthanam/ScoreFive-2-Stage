//
//  NewGameViewController.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/29/20.
//

import ScoreKeeping
import FiveUI
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol NewGameViewControllable: ViewControllable {}

/// @mockable
protocol NewGamePresentableListener: AnyObject {
    func didTapNewGame(with playerNames: [String?], scoreLimit: Int)
}

final class NewGameViewController: ScopeViewController, NewGamePresentable, NewGameViewControllable, UINavigationBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NewPlayerCellDelegate, ScoreLimitCellDelegate {
    
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
    
    // MARK: - NewGamePresentable
    
    weak var listener: NewGamePresentableListener?
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        playerNames.count < 8 ? 3 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return playerNames.count
        } else if section == 2 {
            return 1
        }
        assertionFailure("Invalid Section #")
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "score-limit-cell", for: indexPath) as! ScoreLimitCell
            var config = ScoreLimitCell.buildConfiguration()
            config.delegate = self
            config.defaultScore = "250"
            config.enteredScore = scoreLimit
            cell.contentConfiguration = config
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "new-player-cell", for: indexPath) as! NewPlayerCell
            var config = NewPlayerCell.buildConfiguration()
            config.enteredPlayerName = playerNames[indexPath.row]
            config.playerIndex = indexPath.row
            config.delegate = self
            cell.contentConfiguration = config
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "add-player-cell", for: indexPath) as! AddPlayerCell
            var config = AddPlayerCell.buildConfiguration()
            config.title = "Add Player"
            cell.contentConfiguration = config
            return cell
        } else {
            assertionFailure("Invalid Section #")
            return collectionView.dequeueReusableCell(withReuseIdentifier: "fail-safe", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        indexPath.section == 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 2 {
            addPlayer()
        }
    }
    
    // MARK: - NewPlayerCellDelegate
    
    func didInputPlayerName(input: String?, index: Int) {
        playerNames[index] = input
    }
    
    // MARK: - ScoreLimitCellDelegate
    
    func didInputScoreLimit(input: String?) {
        scoreLimit = input
    }
    
    // MARK: - Private
    
    private let headerView = HeaderView()
    private let newGameButton = NewGameButton()
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.trailingSwipeActionsConfigurationProvider = self.trailingActionsConfigurationsProvider
        config.backgroundColor = .backgroundPrimary
        config.showsSeparators = false
        let layout: UICollectionViewCompositionalLayout = .list(using: config)
        return .init(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var scoreLimit: String? = nil
    private var playerNames: [String?] = [nil, nil]
    
    private func setUp() {
        view.backgroundColor = .backgroundPrimary
        
        headerView.title = "New Game"
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make
                .top
                .leading
                .trailing
                .equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ScoreLimitCell.self,
                                forCellWithReuseIdentifier: "score-limit-cell")
        collectionView.register(NewPlayerCell.self,
                                forCellWithReuseIdentifier: "new-player-cell")
        collectionView.register(AddPlayerCell.self,
                                forCellWithReuseIdentifier: "add-player-cell")
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "fail-safe")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make
                .top
                .equalTo(headerView.snp.bottom)
            make
                .leading
                .trailing
                .bottom
                .equalTo(view.safeAreaLayoutGuide)
        }
        
        view.bringSubviewToFront(headerView)
        view.addSubview(newGameButton)
        
        newGameButton.title = "Start Game"
        newGameButton.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .bottom.equalTo(view.safeAreaLayoutGuide)
            make
                .height
                .equalTo(56.0)
        }
        newGameButton.addTarget(self, action: #selector(didTapNewGame), for: .touchUpInside)
    }
    
    @objc
    private func didTapNewGame() {
        let score: Int = Int(scoreLimit ?? "250") ?? 250
        listener?.didTapNewGame(with: playerNames, scoreLimit: score)
    }
    
    private func trailingActionsConfigurationsProvider(indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1,
              playerNames.count > 2,
              indexPath.row != playerNames.count else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, actionPerformed in
            guard let self = self else {
                actionPerformed(false)
                return
            }
            self.removePlayer(at: indexPath.row)
            actionPerformed(true)
        }
        
        return .init(actions: [deleteAction])
    }
    
    private func removePlayer(at index: Int) {
        playerNames.remove(at: index)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [IndexPath(row: index, section: 1)])
            if playerNames.count == 7 {
                collectionView.insertSections(IndexSet([2]))
            }
        }, completion: { _ in
            self.collectionView.reloadData()
        })
        
    }
    
    private func addPlayer() {
        playerNames.append(nil)
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [IndexPath(row: playerNames.count - 1, section: 1)])
            if playerNames.count == 8 {
                collectionView.deleteSections(IndexSet([2]))
            }
        })
        
    }
    
    private class NewGameButton: BaseControl {
        
        override init() {
            super.init()
            setUp()
        }
        
        var title: String? {
            get { label.text }
            set { label.text = newValue }
        }
        
        override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
            isHighlighted = true
            return true
        }
        
        
        override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
            let point = touch.location(in: self)
            isHighlighted = bounds.contains(point)
            return true
        }
        
        override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
            isHighlighted = false
        }
        
        override var isHighlighted: Bool {
            didSet {
                if isHighlighted {
                    backgroundColor = .contentAccentSecondary
                } else {
                    backgroundColor = .contentAccentPrimary
                }
            }
        }
        
        private let label = UILabel()
        
        private func setUp() {
            backgroundColor = .contentAccentPrimary
            label.textAlignment = .center
            label.textColor = .contentOnColorPrimary
            addSubview(label)
            label.snp.makeConstraints { make in
                make
                    .center
                    .equalToSuperview()
            }
        }
    }
}
