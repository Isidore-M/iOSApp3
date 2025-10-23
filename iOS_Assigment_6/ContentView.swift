//
//  ContentView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-22.
//
import SwiftUI
import Foundation

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NoteViewModel()
    
    // UI States
    @State private var selectedFolderID: UUID?
    @State private var showCreateFolder = false
    @State private var showUnlockSheet = false
    @State private var folderToUnlock: Folder?
    @State private var wrongPasswordAlert = false
    
    // New Note
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
                onFolderSelected: handleFolderSelection, onQuickNoteTapped: handleQuickNote
            )
            
            // MARK: Main Content
            mainContent
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
                            folderToUnlock = nil
                        }
                    }
                ), correctPassword: "1234"
            )
        }
        
        // MARK: Wrong Password Alert
        .alert("Wrong Password", isPresented: $wrongPasswordAlert) {
            Button("OK", role: .cancel) {}
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
                            createNewNote()
                        }
                        .disabled(newNoteTitle.isEmpty)
                    }
                }
            }
        }
    }
    
    // MARK: Main Content
    private var mainContent: some View {
        VStack {
            if let folder = viewModel.folders.first(where: { $0.id == selectedFolderID }) {
                NotesDashboardView(viewModel: viewModel, selectedFolder: folder)
            } else {
                // Default welcome screen
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
                .onAppear {
                    // Default select "All my notes"
                    if let allNotes = viewModel.folders.first(where: { $0.name == "All my notes" }) {
                        selectedFolderID = allNotes.id
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    // MARK: - Logic
    
    private func handleFolderSelection(_ folder: Folder) {
        if folder.isDiary {
            folderToUnlock = folder
        } else {
            selectedFolderID = folder.id
        }
    }
    
    private func handleQuickNote() {
        showNewNoteSheet = true
    }
    
    private func createNewNote() {
        let note = Note(title: newNoteTitle, content: newNoteContent)
        
        // Check if "Quick Notes" folder exists
        if let quickFolder = viewModel.folders.first(where: { $0.name == "Quick Notes" }) {
            viewModel.addNote(note, to: quickFolder.id)
            selectedFolderID = quickFolder.id
        } else {
            // Create folder first
            viewModel.createFolder(name: "Quick Notes")
            if let quickFolder = viewModel.folders.first(where: { $0.name == "Quick Notes" }) {
                viewModel.addNote(note, to: quickFolder.id)
                selectedFolderID = quickFolder.id
            }
        }
        
        // Reset
        showNewNoteSheet = false
        newNoteTitle = ""
        newNoteContent = ""
    }
}

#Preview {
    ContentView()
}
