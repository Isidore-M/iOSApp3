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
        .sheet(isPresented: $showUnlockSheet) {
            if let folder = folderToUnlock {
                DiaryUnlockView(
                    folder: folder,
                    onUnlock: { enteredPassword in
                        handleUnlock(folder: folder, enteredPassword: enteredPassword)
                    }
                )
                .presentationDetents([.height(220)])
            }
        }
        
        // MARK: Wrong Password Alert
        .alert("Wrong Password", isPresented: $wrongPasswordAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    // MARK: Main Content View
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
}

// MARK: - Logic
extension ContentView {
    private func handleFolderSelection(_ folder: Folder) {
        if folder.isDiary {
            folderToUnlock = folder
            showUnlockSheet = true
        } else {
            selectedFolderID = folder.id
        }
    }
    
    private func handleUnlock(folder: Folder, enteredPassword: String) {
        showUnlockSheet = false
        
        if folder.password == enteredPassword {
            selectedFolderID = folder.id
        } else {
            wrongPasswordAlert = true
        }
    }
}
#Preview {
    ContentView()
}
