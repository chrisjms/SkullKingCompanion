//
//  ScoreCalculator.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import Foundation

class ScoreCalculator {
    
    func compute(bet: PlayerBet, roundNumber: Int) -> Int {
        var score: Int = bet.bonusPoints
        if bet.bids == 0 {
            if bet.tricksWon != 0 {
                score += -10 * roundNumber
            } else {
                score += 10 * roundNumber
            }
        } else {
            if bet.bids == bet.tricksWon {
                score += 20 * bet.bids
            } else {
                score += -10 * abs(bet.bids - bet.tricksWon)
            }
        }
        return score
    }
    
}

struct PlayerBet {
    let bids: Int
    let tricksWon: Int
    let bonusPoints: Int
}
