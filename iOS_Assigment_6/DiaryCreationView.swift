//
//  DiaryCreationView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-23.
//

import Foundation
import SwiftUI

struct DiaryCreationView: View {
    @ObservedObject var viewModel: NoteViewModel
    @Binding var isPresented: Bool
    
    @State private var diaryTitle: String = ""
    @State private var diaryPassword: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Diary Title") {
                    TextField("Enter diary title", text: $diaryTitle)
                }
                Section("Password") {
                    SecureField("Enter password", text: $diaryPassword)
                }
            }
            .navigationTitle("Create Diary")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        guard !diaryTitle.isEmpty, !diaryPassword.isEmpty else { return }
                        // Create diary folder
                        viewModel.createFolder(name: diaryTitle, isDiary: true, password: diaryPassword)
                        isPresented = false
                    }
                    .disabled(diaryTitle.isEmpty || diaryPassword.isEmpty)
                }
            }
        }
    }
}
