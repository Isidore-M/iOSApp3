//
//  ContentView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-22.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NoteViewModel()
    
    // UI States
    @State private var selectedFolderID: UUID?
    @State private var showCreateFolder = false
    @State private var folderToUnlock: Folder?
    @State private var wrongPasswordAlert = false
    
    // New Note Sheet
    @State private var showNewNoteSheet = false
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    
    var body: some View {
        HStack(spacing: 0) {
            // MARK: Sidebar
            SidebarView(
                viewModel: viewModel,
                selectedFolderID: $selectedFolderID,
                showCreateFolder: $showCreateFolder,
                showNewNoteSheet: $showNewNoteSheet,
                newNoteTitle: $newNoteTitle,
                newNoteContent: $newNoteContent,
                onFolderSelected: handleFolderSelection
            )
            
            // MARK: Main Content
            if let folderID = selectedFolderID,
               let folder = viewModel.folders.first(where: { $0.id == folderID }) {
                NotesDashboardView(viewModel: viewModel, selectedFolder: folder)
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "pencil.and.outline")
                        .font(.system(size: 70))
                        .foregroundColor(.orange.opacity(0.8))
                    
                    Text("Welcome to Be.note ✨")
                        .font(.title).bold()
                    
                    Text("Select a folder or start a quick note to begin writing.")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
        
        // MARK: Create Folder Popover
        .popover(isPresented: $showCreateFolder) {
            CreateFolderView(viewModel: viewModel)
                .frame(width: 420, height: 260)
        }
        
        // MARK: Unlock Sheet
        .sheet(item: $folderToUnlock) { folder in
            DiaryUnlockView(
                isPresented: Binding(
                    get: { folderToUnlock != nil },
                    set: { if !$0 { folderToUnlock = nil } }
                ),
                isUnlocked: Binding(
                    get: { selectedFolderID == folder.id },
                    set: { unlocked in
                        if unlocked {
                            selectedFolderID = folder.id
                            folderToUnlock = nil
                        } else {
                            wrongPasswordAlert = true
                        }
                    }
                ),
                correctPassword: folder.password ?? ""
            )
        }
        
        // MARK: New Note Sheet
        .sheet(isPresented: $showNewNoteSheet) {
            NavigationView {
                Form {
                    Section("Title") {
                        TextField("Note title", text: $newNoteTitle)
                    }
                    Section("Content") {
                        TextEditor(text: $newNoteContent)
                            .frame(height: 200)
                    }
                }
                .navigationTitle("New Note")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showNewNoteSheet = false
                            newNoteTitle = ""
                            newNoteContent = ""
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let note = Note(title: newNoteTitle, content: newNoteContent)
                            if let folderID = selectedFolderID {
                                viewModel.addNote(note, to: folderID)
                            }
                            showNewNoteSheet = false
                            newNoteTitle = ""
                            newNoteContent = ""
                        }
                        .disabled(newNoteTitle.isEmpty)
                    }
                }
            }
        }
        
        // MARK: Wrong Password Alert
        .alert("Wrong Password", isPresented: $wrongPasswordAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    // MARK: - Logic
    private func handleFolderSelection(_ folder: Folder) {
        if folder.isDiary {
            folderToUnlock = folder
        } else {
            selectedFolderID = folder.id
        }
    }
}

#Preview {
    ContentView()
}

