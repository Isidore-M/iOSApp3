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
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Banner (only for "All my notes")
            if selectedFolder.name == "All my notes" {
                ZStack {
                    Color.blue.opacity(0.15)
                        .cornerRadius(15)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Life is an adventure")
                                .font(.title2)
                                .bold()
                            Text("Write yours here")
                                .font(.title2)
                                .fontWeight(.regular)
                            Button("Create my diary") {
                                // TODO: Add action
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        Spacer()
                        
                        Image("banner") // Placeholder illustration
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .foregroundColor(.orange)
                    }
                    .padding()
                }
                .frame(height: 200) // fixed banner height
                    .padding(.horizontal)
                    .padding(.top, 50)
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
            .padding(.top, 40)
            
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
                            let note = Note(title: newNoteTitle, content: newNoteContent)
                            viewModel.addNote(note, to: selectedFolder.id)
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
                        Button("Close") {
                            selectedNote = nil
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Filter Notes
    private func filteredNotes() -> [Note] {
        if searchText.isEmpty {
            return selectedFolder.notes
        } else {
            return selectedFolder.notes.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
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
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8)*17, (int >> 4 & 0xF)*17, (int & 0xF)*17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
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
