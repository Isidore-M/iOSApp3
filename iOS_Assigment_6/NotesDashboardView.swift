//
//  NotesDashboardView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-23.
//
import SwiftUI

struct NotesDashboardView: View {
    @ObservedObject var viewModel: NoteViewModel
    var selectedFolder: Folder
    
    @State private var showNewNoteSheet = false
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    
    @State private var searchText = ""
    @State private var selectedNote: Note? = nil
    
    // Diary creation
    @State private var showDiaryCreation = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Banner (only for "All my notes")
            if selectedFolder.name == "All my notes" {
                ZStack {
                    Color.blue.opacity(0.15)
                        .cornerRadius(15)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Life is an adventure")
                                .font(.title3)
                                .bold()
                            Text("Write yours here....")
                                .font(.title3)
                                .fontWeight(.regular)
                            
                            Button("Create my diary") {
                                showDiaryCreation = true
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        Spacer()
                        
                        Image("banner") // Placeholder illustration
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .foregroundColor(.orange)
                    }
                    .padding(12)
                }
                .frame(height: 200)
                .padding(.horizontal)
                .padding(.top, 40)
            } else {
                // Show folder name for context
                Text(selectedFolder.name)
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 40)
            }
            
            // MARK: Search + Add Note
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search notes...", text: $searchText)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button(action: { showNewNoteSheet = true }) {
                    Text("Add a note")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // MARK: Notes Grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(filteredNotes()) { note in
                        Button(action: { selectedNote = note }) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(note.title)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(note.content)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(randomBackground(for: note))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            
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
                            // Add new note to Quick Notes if "All my notes" selected
                            if selectedFolder.name == "All my notes" {
                                var quickNotesFolder = viewModel.folders.first { $0.name == "Quick Notes" }
                                if quickNotesFolder == nil {
                                    // Create Quick Notes folder
                                    viewModel.createFolder(name: "Quick Notes")
                                    quickNotesFolder = viewModel.folders.first { $0.name == "Quick Notes" }
                                }
                                if let folder = quickNotesFolder {
                                    let note = Note(title: newNoteTitle, content: newNoteContent)
                                    viewModel.addNote(note, to: folder.id)
                                }
                            } else {
                                let note = Note(title: newNoteTitle, content: newNoteContent)
                                viewModel.addNote(note, to: selectedFolder.id)
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
        
        // MARK: Note Detail Sheet
        .sheet(item: $selectedNote) { note in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(note.title)
                            .font(.largeTitle)
                            .bold()
                        Text(note.content)
                            .font(.body)
                    }
                    .padding()
                }
                .navigationTitle("Note")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Close") { selectedNote = nil }
                    }
                }
            }
        }
        
        // MARK: Diary Creation Sheet
        .sheet(isPresented: $showDiaryCreation) {
            DiaryCreationView(viewModel: viewModel, isPresented: $showDiaryCreation)
        }
    }
    
    // MARK: Filter Notes
    private func filteredNotes() -> [Note] {
        let notesToShow: [Note] = {
            if selectedFolder.name == "All my notes" {
                return viewModel.folders.flatMap { $0.notes }.sorted { $0.dateCreated > $1.dateCreated }
            } else {
                return selectedFolder.notes
            }
        }()
        
        if searchText.isEmpty { return notesToShow }
        
        return notesToShow.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: Pastel Background
    private func randomBackground(for note: Note) -> Color {
        let colors = [Color(hex: "#FFEBDD"), Color(hex: "#E7F7FF")]
        return colors[note.id.uuidString.hashValue % colors.count]
    }
}

// MARK: - Hex Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8)*17, (int >> 4 & 0xF)*17, (int & 0xF)*17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r)/255,
            green: Double(g)/255,
            blue: Double(b)/255,
            opacity: Double(a)/255
        )
    }
}
