//
//  RoundViewModel.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import Foundation
import Combine

struct RoundPlayerItem {
    let id: String
    let name: String
    let score: Int
    let hasTheBetterScore: Bool
    let bids: Int
    let tricksWon: Int
    let bonusPoints: Int
    let onNewBid: (Int) -> Void
    let onNewTricksWon: (Int) -> Void
    let onNewBonusPoints: (Int) -> Void
}

@MainActor
class RoundViewModel: ObservableObject {
    
    @Published private (set) var game: Game?
    @Published private (set) var roundPlayerItems = [RoundPlayerItem]()
    var bidsPossibilites: [Int] {
        guard let game else { return [] }
        return (0...game.roundNumber).map { $0 }
    }

    private let gameRepository: GameRepository
    private let playerRepository: PlayerRepository
    private let scoreCalculator: ScoreCalculator
    
    private var cancellables = Set<AnyCancellable>()

    init(
        gameId: String,
        scoreCalculator: ScoreCalculator,
        gameRepository: GameRepository,
        playerRepository: PlayerRepository
    ) {
        self.scoreCalculator = scoreCalculator
        self.gameRepository = gameRepository
        self.playerRepository = playerRepository
        
        gameRepository.observeGame(id: gameId)
            .sink { _ in
            } receiveValue: { [weak self] game in
                guard let game else { return }
                self?.game = game
            }
            .store(in: &cancellables)
        
        playerRepository.observePlayers(gameId: gameId)
            .sink { _ in
            } receiveValue: { [weak self] players in
                let playersWithBetterScore: [Player] = players.filter { $0.score == players.max(by: { $0.score < $1.score })?.score }
                self?.roundPlayerItems = players.map { player in
                    let hasTheBetterScore = playersWithBetterScore.first(where: { $0.id == player.id }) != nil
                    return RoundPlayerItem(
                        player,
                        hasTheBetterScore: hasTheBetterScore,
                        onNewBid: { [weak self] bid in
                            self?.onNewBid(id: player.id, bid: bid)
                        },
                        onNewTricksWon: { [weak self] trickWons in
                            self?.onNewTrickWons(id: player.id, tricks: trickWons)
                        },
                        onNewBonusPoints: { [weak self] bonusPoints in
                            self?.onNewBonusPoints(id: player.id, bonusPoints: bonusPoints)
                        }
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    func onNextRound() {
        guard let game else { return }
        var scores = [String: Int]()
        roundPlayerItems.forEach { roundPlayerItem in
            let bet = PlayerBet(
                bids: roundPlayerItem.bids,
                tricksWon: roundPlayerItem.tricksWon,
                bonusPoints: roundPlayerItem.bonusPoints
            )
            let score = scoreCalculator.compute(bet: bet, roundNumber: game.roundNumber)
            scores[roundPlayerItem.id] = score
        }
        // rendre async
        scores.forEach { id, score in
            Task {
                do {
                    try await playerRepository.setPlayerScore(id: id, score: score)
                } catch {
                    print("error setting new scores")
                }
            }
        }
        Task {
            do {
                try await gameRepository.onNextRound(id: game.id)
            } catch {
                print("error setting new scores")
            }
        }
    }
    
    private func onNewBid(id: String, bid: Int) {
        Task {
            do {
                try await self.playerRepository.setNewBid(id: id, bid: bid)
            } catch {
                print("Error setting new bid")
            }
        }
    }
    
    private func onNewTrickWons(id: String, tricks: Int) {
        Task {
            do {
                try await self.playerRepository.setNewTricks(id: id, trickWons: tricks)
            } catch {
                print("Error setting new bid")
            }
        }
    }
    
    private func onNewBonusPoints(id: String, bonusPoints: Int) {
        Task {
            do {
                try await self.playerRepository.setNewBonusPoints(id: id, bonusPoints: bonusPoints)
            } catch {
                print("Error setting new bid")
            }
        }
    }
}

extension RoundPlayerItem {
    init(
        _ player: Player,
        hasTheBetterScore: Bool,
        onNewBid: @escaping (Int) -> Void,
        onNewTricksWon: @escaping (Int) -> Void,
        onNewBonusPoints: @escaping (Int) -> Void
    ) {
        self.id = player.id
        self.name = player.name
        self.score = player.score
        self.hasTheBetterScore = hasTheBetterScore
        self.bids = player.bid
        self.tricksWon = player.trickWons
        self.bonusPoints = player.bonusPoints
        self.onNewBid = onNewBid
        self.onNewTricksWon = onNewTricksWon
        self.onNewBonusPoints = onNewBonusPoints
    }
}
