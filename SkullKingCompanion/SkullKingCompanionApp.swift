//
//  SkullKingCompanionApp.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import SwiftUI
import UIPilot

@main
struct SkullKingCompanionApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    
    @StateObject private var dependenciesContainer: DependenciesContainer
    @StateObject var appRouter = AppRouter(initial: .lobby)

    init() {
        _dependenciesContainer = StateObject(wrappedValue: DependenciesContainer())
    }
    
    var body: some View {
        UIPilotHost(appRouter.pilot) { route in
            switch route {
            case .lobby:
                LobbyView(viewModel: dependenciesContainer.makeLobbyViewModel())
            case .newGame:
                NewGameView(viewModel: dependenciesContainer.makeNewGameViewModel())
            case .round(let gameId):
                RoundView(viewModel: dependenciesContainer.makeRoundViewModel(gameId: gameId))
            }
        }
        .environmentObject(appRouter)
        .navigationBarTitleDisplayMode(.inline)
    }
}

class AppRouter: ObservableObject {
    @Published var pilot: UIPilot<AppRoute>
    
    init(initial: AppRoute) {
        self.pilot = UIPilot(initial: initial)
    }
    
    func push(_ route: AppRoute) {
        pilot.push(route)
    }
    
    func pop() {
        pilot.pop()
    }
}

enum AppRoute: Equatable {
    case lobby
    case newGame
    case round(gameId: String)
}
