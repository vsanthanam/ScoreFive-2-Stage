//
//  ScoreCardInteractor.swift
//  ScoreFive
//
//  Created by Varun Santhanam on 12/30/20.
//

import Combine
import Foundation
import ScoreKeeping
import ShortRibs

/// @mockable
protocol ScoreCardPresentable: ScoreCardViewControllable {
    var listener: ScoreCardPresentableListener? { get set }
    func reload()
}

/// @mockable
protocol ScoreCardListener: AnyObject {
    func scoreCardDidDeleteRound(at index: Int)
}

final class ScoreCardInteractor: PresentableInteractor<ScoreCardPresentable>, ScoreCardInteractable, ScoreCardPresentableListener {
    
    // MARK: - Initializers
    
    init(presenter: ScoreCardPresentable,
         gameStorageProvider: GameStorageProviding,
         activeGameStream: ActiveGameStreaming) {
        self.gameStorageProvider = gameStorageProvider
        self.activeGameStream = activeGameStream
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - API
    
    weak var listener: ScoreCardListener?
    
    // MARK: - Interactor
    
    override func didBecomeActive() {
        super.didBecomeActive()
        startObservingScoreCardChanges()
    }
    
    // MARK: - ScoreCardInteractabble
    
    var viewController: ScoreCardViewControllable {
        presenter
    }
    
    // MARK: - ScoreCardPresentableListener
    
    var numberOfRounds: Int {
        currentScoreCard?.numberOfRounds ?? 0
    }
    
    var orderedPlayers: [Player] {
        currentScoreCard?.orderedPlayers ?? []
    }
    
    func round(at index: Int) -> Round? {
        currentScoreCard?[index]
    }
    
    func canRemoveRow(at index: Int) -> Bool {
        currentScoreCard?.canRemoveRound(at: index) ?? false
    }
    
    func didRemoveRow(at index: Int) {
        listener?.scoreCardDidDeleteRound(at: index)
    }
    
    func index(at index: Int) -> String? {
        return String(index)
    }
    
    // MARK: - Private
    
    private let gameStorageProvider: GameStorageProviding
    private let activeGameStream: ActiveGameStreaming
    
    private var automaticReload: Bool = true
    
    private var currentScoreCard: ScoreCard? {
        didSet {
            presenter.reload()
        }
    }
    
    private func startObservingScoreCardChanges() {
        activeGameStream.activeGameIdentifier
            .filterNil()
            .map { [gameStorageProvider] identifier in
                gameStorageProvider.scoreCard(for: identifier)
            }
            .switchToLatest()
            .filterNil()
            .toOptional()
            .assign(to: \.currentScoreCard, on: self)
            .cancelOnDeactivate(interactor: self)
    }
}

