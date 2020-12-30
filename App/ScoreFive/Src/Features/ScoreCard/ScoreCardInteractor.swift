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
    func update(scoreCard: ScoreCard)
}

/// @mockable
protocol ScoreCardListener: AnyObject {}

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
    
    // MARK: - ScoreCardInteractabble
    
    var viewController: ScoreCardViewControllable {
        presenter
    }
    
    // MARK: - Private
    
    private let gameStorageProvider: GameStorageProviding
    private let activeGameStream: ActiveGameStreaming
    
    private var scoreCard: ScoreCard?
    
    private func startObservingScoreCardChanges() {
        
        func cardStream(for identifier: UUID) -> AnyPublisher<ScoreCard?, Never> {
            gameStorageProvider.scoreCard(for: identifier)
        }
        
        activeGameStream.activeGameIdentifier
            .filterNil()
            .map(cardStream(for:))
            .switchToLatest()
            .filterNil()
            .toOptional()
            .assign(to: \.scoreCard, on: self)
            .cancelOnDeactivate(interactor: self)
    }
}

