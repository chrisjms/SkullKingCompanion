//
//  LobbyView.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import SwiftUI
import UIPilot

struct LobbyView: View {
    @ObservedObject var viewModel: LobbyViewModel
    var body: some View {
        LobbyScreen(
            startedGames: viewModel.startedGames
        )
    }
}

private struct LobbyScreen: View {
    
    @EnvironmentObject var appRouter: AppRouter
    
    let startedGames: [Game]
    var body: some View {
        VStack {
            Button(
                action: { appRouter.push(.newGame) },
                label: {
                    Text("Start new game")
                }
            )
            if !startedGames.isEmpty {
                Button(
                    action: {},
                    label: {
                        Text("See last games")
                    }
                )
            }
        }
    }
}

#Preview {
    LobbyScreen(
        startedGames: [
            Game(id: "id1", state: .started, roundNumber: 2)
        ]
    )
}
