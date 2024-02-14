//
//  RoundView.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import SwiftUI

struct RoundView: View {
    @ObservedObject var viewModel: RoundViewModel
    var body: some View {
        if let game = viewModel.game {
            RoundScreen(
                game: game,
                bidsPossibilities: viewModel.bidsPossibilites,
                players: viewModel.roundPlayerItems,
                onNextRound: viewModel.onNextRound
            )
        }
    }
}

private struct RoundScreen: View {
    let game: Game
    let bidsPossibilities: [Int]
    let players: [RoundPlayerItem]
    let onNextRound: () -> Void
    var body: some View {
        VStack {
            ScoreBoardView(players: players)
            Text("Round \(game.roundNumber)")
            List(players, id: \.id) { player in
                PlayerBetListItem(
                    bidsPossibilities: bidsPossibilities,
                    player: player
                )
            }
            .listRowSpacing(30)
            Button(action: onNextRound) {
                HStack {
                    Spacer()
                    Text("Next round!")
                    Spacer()
                }.background(Color.red)
            }
        }
    }
}

private struct ScoreBoardView: View {
    let players: [RoundPlayerItem]
    var body: some View {
        Text("Score board")
        ForEach(players, id: \.id) { player in
            HStack {
                if player.hasTheBetterScore {
                    // Show something to indicate it
                }
                Text(player.name)
                Text("\(player.score)")
            }
        }
    }
}

private struct PlayerBetListItem: View {
    let bidsPossibilities: [Int]
    let player: RoundPlayerItem
    var body: some View {
        VStack {
            Text(player.name)
            BidsView(
                bidsPossibilities: bidsPossibilities,
                bids: player.bids,
                onNewBid: player.onNewBid
            )
            TricksWonView(
                bidsPossibilities: bidsPossibilities,
                tricksWon: player.tricksWon,
                onNewTricksWon: player.onNewTricksWon
            )
            RoundStepper(
                bonusPoints: player.bonusPoints,
                onNewBonusPoints: player.onNewBonusPoints
            )
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.blue)
    }
}

private struct BidsView: View {
    let bidsPossibilities: [Int]
    let bids: Int
    let onNewBid: (Int) -> Void
    var body: some View {
        HStack {
            Text("bids")
            Picker(
                "",
                selection: Binding(
                    get: { bids },
                    set: { newBid in
                        onNewBid(newBid)
                    }
                )
            ) {
                ForEach(bidsPossibilities, id: \.self) { value in
                    Text("\(value)")
                }
            }
        }
    }
}

private struct TricksWonView: View {
    let bidsPossibilities: [Int]
    let tricksWon: Int
    let onNewTricksWon: (Int) -> Void
    var body: some View {
        HStack {
            Text("tricks won")
            Picker(
                "",
                selection: Binding(
                    get: { tricksWon },
                    set: { newTrick in
                        onNewTricksWon(newTrick)
                    }
                )
            ) {
                ForEach(bidsPossibilities, id: \.self) { value in
                    Text("\(value)")
                }
            }
        }
    }
}

private struct RoundStepper: View {
    let bonusPoints: Int
    let onNewBonusPoints: (Int) -> Void
    var body: some View {
        Stepper(
            "Bonus points: \(bonusPoints)",
            value: Binding(
                get: { bonusPoints },
                set: { newBonus in
                    onNewBonusPoints(newBonus)
                }
            ),
            step: 10
        )
        .padding(.horizontal)
    }
}

#Preview {
    RoundScreen(
        game: Game(id: "id", state: .started, roundNumber: 4),
        bidsPossibilities: [1,2,3,4],
        players: [
            RoundPlayerItem(
                id: "id1",
                name: "Jacques",
                score: 30,
                hasTheBetterScore: true,
                bids: 2,
                tricksWon: 1,
                bonusPoints: 10,
                onNewBid: { _ in },
                onNewTricksWon: { _ in },
                onNewBonusPoints: { _ in }
            ),
            RoundPlayerItem(
                id: "id2",
                name: "Marc",
                score: 30,
                hasTheBetterScore: true,
                bids: 2,
                tricksWon: 1,
                bonusPoints: 10,
                onNewBid: { _ in },
                onNewTricksWon: { _ in },
                onNewBonusPoints: { _ in }
            ),
            RoundPlayerItem(
                id: "id3",
                name: "Henry",
                score: 20,
                hasTheBetterScore: false,
                bids: 2,
                tricksWon: 1,
                bonusPoints: 10,
                onNewBid: { _ in },
                onNewTricksWon: { _ in },
                onNewBonusPoints: { _ in }
            )
        ],
        onNextRound: {}
    )
}
