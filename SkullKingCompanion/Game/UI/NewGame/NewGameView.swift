//
//  NewGameView.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import SwiftUI
import UIPilot

struct NewGameView: View {
    @ObservedObject var viewModel: NewGameViewModel
    var body: some View {
        NewGameScreen(
            gameId: viewModel.gameId,
            players: viewModel.playerItems,
            onAddPlayer: viewModel.onAddPlayer,
            onStartGame: viewModel.onStartNewGame
        )
    }
}

private struct NewGameScreen: View {
    @EnvironmentObject var appRouter: AppRouter
    let gameId: String
    let players: [PlayerItem]
    let onAddPlayer: () -> Void
    let onStartGame: () async -> Void
    var body: some View {
        VStack {
            List(players, id: \.id) { player in
                Text(player.name)
            }
            Button(
                action: onAddPlayer,
                label: {
                    Text("Add new player")
                }
            )
            Button(
                action: {
                    Task {
                        await onStartGame()
                        appRouter.push(.round(gameId: gameId))
                    }
                },
                label: {
                    Text("Start game")
                }
            )
        }
    }
}

#Preview {
    NewGameScreen(
        gameId: "19",
        players: [
            PlayerItem(id: "1", name: "Jacques"),
            PlayerItem(id: "2", name: "Henry"),
            PlayerItem(id: "3", name: "Herault")
        ],
        onAddPlayer: {},
        onStartGame: {}
    )
}
