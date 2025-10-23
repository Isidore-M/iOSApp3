//
//  CreateFolderView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-22.
//

import Foundation
import SwiftUI

struct CreateFolderView: View {
    @ObservedObject var viewModel: NoteViewModel
    
    @State private var folderName = ""
    @State private var isDiary = false
    @State private var password = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create a new folder")
                .font(.title2).bold()
            
            TextField("Folder name", text: $folderName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Toggle("This is a diary (requires password)", isOn: $isDiary)
                .toggleStyle(SwitchToggleStyle(tint: .orange))
            
            if isDiary {
                SecureField("Enter password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Spacer()
            
            HStack {
                Button("Cancel") { dismiss() }
                    .foregroundColor(.gray)
                Spacer()
                Button("Create") {
                    viewModel.createFolder(name: folderName, isDiary: isDiary, password: isDiary ? password : nil)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .disabled(folderName.isEmpty)
            }
        }
        .padding()
    }
}
