//
//  SignupView.swift
//  task-tracker-swiftui
//
//  Created by Andrew Morgan on 03/11/2020.
//

import SwiftUI
import RealmSwift

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var state: AppState
    @State var error: String?
    @State private var username = ""
    @State private var password = ""

    private enum Dimensions {
        static let topInputFieldPadding: CGFloat = 32.0
        static let buttonPadding: CGFloat = 24.0
        static let topPadding: CGFloat = 48.0
        static let padding: CGFloat = 16.0
    }

    var body: some View {
        VStack(spacing: Dimensions.padding) {
            InputField(title: "Email/Username",
                       text: self.$username)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            InputField(title: "Password",
                       text: self.$password,
                       showingSecureField: true)
            CallToActionButton(
                title: "Sign Up",
                action: { self.signup(username: self.username, password: self.password) })
            if let error = error {
                Text("Error: \(error)")
                    .foregroundColor(Color.red)
            }
        }
        .padding(.horizontal, Dimensions.padding)
    }

    private func signup(username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            return
        }
        self.error = nil
        state.shouldIndicateActivity = true
        app.emailPasswordAuth.registerUser(email: username, password: password) { error in
            DispatchQueue.main.sync {
                state.shouldIndicateActivity = false
                if let error = error {
                    print("Signup failed: \(error)")
                    self.error = "Signup failed: \(error.localizedDescription)"
                } else {
                    print("Signup successful")
                }
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SignupView()
                    .environmentObject(AppState())
            }
            .preferredColorScheme(.light)
            NavigationView {
                SignupView()
                    .environmentObject(AppState())
            }
            .preferredColorScheme(.dark)
        }
    }
}