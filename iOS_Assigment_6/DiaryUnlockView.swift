//
//  DiaryUnlockView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-23.
//

import Foundation
import SwiftUI

struct DiaryUnlockView: View {
    @Binding var isPresented: Bool        // Controls whether the sheet is shown
    @Binding var isUnlocked: Bool         // Updates main view when unlocked
    @State private var password: String = ""  // User input
    @State private var showError: Bool = false
    
    // Replace with your diary password
    private let correctPassword = "1234"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Text("Enter Diary Password")
                    .font(.headline)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                
                if showError {
                    Text("Incorrect password")
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        if password == correctPassword {
                            isUnlocked = true
                            isPresented = false
                        } else {
                            showError = true
                        }
                    }) {
                        Text("Unlock")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationTitle("Unlock Diary")
        }
        .interactiveDismissDisabled() // Prevent swipe-down dismissal if needed
    }
}

struct DiaryUnlockView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryUnlockView(isPresented: .constant(true), isUnlocked: .constant(false))
    }
}
