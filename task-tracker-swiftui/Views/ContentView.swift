//
//  ContentView.swift
//  task-tracker-swiftui
//
//  Created by Andrew Morgan on 03/11/2020.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var state: AppState

//    try {
//        let realm = try Realm()
//    } catch error {
//        // Handle error
//        fatalError("Failed to open Realm. Error: \(error.localizedDescription)")
//      }
    let realm = try! Realm()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if state.loggedIn {
                        ProjectsView()
                            .environmentObject(ActivityStore(realm: realm))
                    } else {
                        LoginView()
                    }
                    Spacer()
                    if let error = state.error {
                        Text("Error: \(error)")
                            .foregroundColor(Color.red)
                    }
                }
                if state.shouldIndicateActivity {
                    OpaqueProgressView("Working With Realm")
                }
            }
            .navigationBarItems(leading: state.loggedIn ? LogoutButton() : nil)
        }
        .currentDeviceNavigationViewStyle(alwaysStacked: !state.loggedIn)
    }
}

extension View {
    public func currentDeviceNavigationViewStyle(alwaysStacked: Bool) -> AnyView {
        if UIDevice.current.userInterfaceIdiom == .pad && !alwaysStacked {
            return AnyView(self.navigationViewStyle(DefaultNavigationViewStyle()))
        } else {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreviews(
            Group {
                ContentView()
                    .environmentObject(AppState())
                Landscape(ContentView()
                    .environmentObject(AppState()))
            }
        )
    }
}
