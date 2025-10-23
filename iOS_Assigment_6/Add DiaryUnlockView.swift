//
//  Add DiaryUnlockView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-22.
//

import Foundation
import SwiftUI

struct DiaryUnlockView: View {
    let folder: Folder
    var onUnlock: (String) -> Void
    
    @State private var password = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Unlock Diary")
                .font(.title2).bold()
            
            Text("Enter password to open \"\(folder.name)\"")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.gray)
                Spacer()
                Button("Unlock") {
                    onUnlock(password)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .disabled(password.isEmpty)
            }
        }
        .padding()
    }
}
