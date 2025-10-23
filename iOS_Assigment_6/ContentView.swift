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
    @State private var showUnlockSheet = false
    @State private var folderToUnlock: Folder?
    @State private var wrongPasswordAlert = false
    @State private var searchText = ""
    
    var body: some View {
        HStack(spacing: 0) {
            // MARK: Sidebar
            SidebarView(
                viewModel: viewModel,
                selectedFolderID: $selectedFolderID,
                showCreateFolder: $showCreateFolder,
                onFolderSelected: handleFolderSelection
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
                        }
                    }
                )
            )
        }
        
        // MARK: Wrong Password Alert
        .alert("Wrong Password", isPresented: $wrongPasswordAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    // MARK: Main Content
    private var mainContent: some View {
        VStack {
            if let selectedFolder = viewModel.folders.first(where: { $0.id == selectedFolderID }) {
                NotesListView(folder: selectedFolder, viewModel: viewModel)
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
}

#Preview {
    ContentView()
}
    
