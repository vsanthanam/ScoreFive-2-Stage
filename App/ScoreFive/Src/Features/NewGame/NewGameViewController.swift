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

final class NewGameViewController: ScopeViewController, NewGamePresentable, NewGameViewControllable, NewGameScoreLimitCellDelegate, NewGamePlayerNameCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - NewGamePresentable
    
    weak var listener: NewGamePresentableListener?
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        enteredPlayerNames.count < 8 ? 3 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return enteredPlayerNames.count
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .scoreLimitCellIdentifier,
                                                     for: indexPath) as! NewGameScoreLimitCell
            var config = NewGameScoreLimitCell.newConfiguration()
            config.defaultScore = "250"
            config.enteredScore = enteredScoreLimit
            config.delegate = self
            cell.contentConfiguration = config
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .newPlayerCellIdentifier, for: indexPath) as! NewGamePlayerNameCell
            var config = NewGamePlayerNameCell.newConfiguration()
            config.delegate = self
            config.playerIndex = indexPath.row
            config.enteredPlayerName = enteredPlayerNames[indexPath.row]
            cell.contentConfiguration = config
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .addPlayerCellIdentifier, for: indexPath) as! NewGameAddPlayerCell
            var config = NewGameAddPlayerCell.newConfiguration()
            config.title = "Add Player"
            cell.contentConfiguration = config
            return cell
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        indexPath.section == 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        addPlayer()
    }

    // MARK: - NewGameScoreLimitCellDelegate
    
    func didInputScoreLimit(input: String?) {
        enteredScoreLimit = input
    }
    
    // MARK: - NewGamePlayerNameCellDelegate
    
    func didInputPlayerName(input: String?, index: Int) {
        enteredPlayerNames[index] = input
    }
    
    // MARK: - Private
    
    private let spacerView = BaseView()
    private let headerView = HeaderView()
    private let newGameButton = NewGameButton()
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        config.backgroundColor = .backgroundPrimary
        config.trailingSwipeActionsConfigurationProvider = trailingSwipeActionsConfigurationProvider
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private var enteredScoreLimit: String? = nil
    private var enteredPlayerNames: [String?] = [nil, nil]
    
    private func setUp() {
        specializedView.backgroundColor = .backgroundPrimary
        
        spacerView.backgroundColor = .backgroundInversePrimary
        specializedView.addSubview(spacerView)
        
        headerView.title = "New Game"
        specializedView.addSubview(headerView)
        
        collectionView.backgroundColor = .backgroundPrimary
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewGameScoreLimitCell.self, forCellWithReuseIdentifier: .scoreLimitCellIdentifier)
        collectionView.register(NewGamePlayerNameCell.self, forCellWithReuseIdentifier: .newPlayerCellIdentifier)
        collectionView.register(NewGameAddPlayerCell.self, forCellWithReuseIdentifier: .addPlayerCellIdentifier)
        specializedView.addSubview(collectionView)
        
        newGameButton.addTarget(self, action: #selector(didTapNewGame), for: .touchUpInside)
        specializedView.addSubview(newGameButton)
        
        spacerView.snp.makeConstraints { make in
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
                .top
                .leading
                .trailing
                .equalTo(specializedView.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .equalTo(specializedView.safeAreaLayoutGuide)
                .inset(16.0)
            make
                .bottom
                .equalTo(newGameButton.snp.top)
            make
                .top
                .equalTo(headerView.snp.bottom)
        }
        
        newGameButton.snp.makeConstraints { make in
            make
                .leading
                .trailing
                .bottom
                .equalTo(specializedView.safeAreaLayoutGuide)
                .inset(16.0)
        }
    }
        
    private func trailingSwipeActionsConfigurationProvider(_ indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1, enteredPlayerNames.count > 2 else {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { [weak self] _, _, actionPerformed  in
            guard let self = self else {
                actionPerformed(false)
                return
            }
            self.removePlayer(at: indexPath.row)
            actionPerformed(true)
        }
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    private func addPlayer() {
        precondition(enteredPlayerNames.count < 8)
        enteredPlayerNames.append(nil)
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [IndexPath(row: enteredPlayerNames.count - 1, section: 1)])
            if enteredPlayerNames.count == 8 {
                collectionView.deleteSections(IndexSet([2]))
            }
        }, completion: nil)
    }
    
    private func removePlayer(at index: Int) {
        precondition(enteredPlayerNames.count > 2)
        enteredPlayerNames.remove(at: index)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [IndexPath(row: index, section: 1)])
            if enteredPlayerNames.count == 7 {
                collectionView.insertSections(IndexSet([2]))
            }
        }, completion: { [weak self] _ in
            self?.collectionView.reloadData()
        })
    }
    
    @objc
    private func didTapNewGame() {
        let scoreLimit = Int(enteredScoreLimit ?? "250") ?? 250
        listener?.didTapNewGame(with: enteredPlayerNames, scoreLimit: scoreLimit)
    }
}


fileprivate extension String {
    static var scoreLimitCellIdentifier: String { "score-limit-cell-identifier" }
    static var newPlayerCellIdentifier: String { "new-player-limit-cell-identifier" }
    static var addPlayerCellIdentifier: String { "add-player-cell-identifier" }
}

extension UICollectionView {
    var widestCellWidth: CGFloat {
        let insets = contentInset.left + contentInset.right
        return bounds.width - insets
    }
}
