//
//  NotesDashboardView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-23.
//
import SwiftUI
import Foundation

struct NotesDashboardView: View {
    @ObservedObject var viewModel: NoteViewModel
    var selectedFolder: Folder
    
    @State private var searchText = ""
    @State private var showNewNoteSheet = false
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    
    private let pastelColors: [Color] = [
        Color(hex: "#FFEBDD"),
        Color(hex: "#E7F7FF"),
        Color(hex: "#FFF5E6"),
        Color(hex: "#F0F7FF")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: Header banner
                headerView
                
                // MARK: Search + Add Note
                HStack {
                    TextField("Search notes...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 10)
                    
                    Button(action: { showNewNoteSheet = true }) {
                        Text("Add a note")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                // MARK: Notes Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(filteredNotes, id: \.id) { note in
                        NoteCardView(note: note, color: pastelColors.randomElement() ?? .orange)
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showNewNoteSheet) {
            newNoteSheet
        }
    }
    
    // MARK: Filtered notes
    private var filteredNotes: [Note] {
        let notes = selectedFolder.name == "Quick Notes" ? viewModel.folders.first(where: { $0.name == "Quick Notes" })?.notes ?? [] : selectedFolder.notes
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.content.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // MARK: Header
    private var headerView: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 180)
                .cornerRadius(20)
                .shadow(radius: 5)
            
            VStack {
                Text("Life is an adventure")
                    .font(.title2).bold()
                    .foregroundColor(.white)
                Button("Create my diary") {
                    // action here
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.8))
                .foregroundColor(.orange)
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: New Note Sheet
    private var newNoteSheet: some View {
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
                        if selectedFolder.name == "Quick Notes" {
                            viewModel.addQuickNote(note)
                        } else {
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
}

// MARK: Note Card View
struct NoteCardView: View {
    var note: Note
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.title)
                .font(.headline)
            Text(note.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(4)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(color.opacity(0.3))
        .cornerRadius(12)
    }
}

// MARK: Color helper
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // skip #
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
