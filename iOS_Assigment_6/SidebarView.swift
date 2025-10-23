//
//  SidebarView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-22.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: NoteViewModel
    @Binding var selectedFolderID: UUID?
    @Binding var showCreateFolder: Bool
    var onFolderSelected: (Folder) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // MARK: Header
            HStack {
                Text("Be.note")
                    .font(.title2.bold())
                    .foregroundColor(.purple)
                Spacer()
                Button(action: { showCreateFolder = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.purple)
                }
            }
            .padding()
            
            Divider()
            
            // MARK: Quick Notes Section
            Section(header: Text("Quick Notes")
                        .font(.headline)
                        .padding(.horizontal)) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.quickNotes) { note in
                            Button(action: {
                                selectedFolderID = nil
                            }) {
                                HStack {
                                    Image(systemName: "note.text")
                                    Text(note.title)
                                        .lineLimit(1)
                                }
                                .foregroundColor(.primary)
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Divider().padding(.vertical, 4)
            
            // MARK: Folders Section
            Section(header: Text("Folders")
                        .font(.headline)
                        .padding(.horizontal)) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.folders) { folder in
                            Button(action: { onFolderSelected(folder) }) {
                                HStack {
                                    Image(systemName: folder.isDiary ? "lock.fill" : "folder.fill")
                                        .foregroundColor(folder.isDiary ? .orange : .blue)
                                    Text(folder.name)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedFolderID == folder.id ? Color.purple.opacity(0.1) : Color.clear)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .frame(width: 280)
        .background(Color(UIColor.systemGroupedBackground))
    }
}

