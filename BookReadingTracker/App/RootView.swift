//
//  RootView.swift
//  BookReadingTracker
//
//  Chooses between the login (Face ID) screen and the main app.
//  The shelf is locked again whenever the app moves to the background.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject private var auth: AuthViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if auth.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: auth.isAuthenticated)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                auth.lock()
            }
        }
    }
}
