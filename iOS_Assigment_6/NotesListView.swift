//
//  NotesListView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-23.
//

import Foundation
import SwiftUI

struct NotesListView: View {
    var folder: Folder
    @ObservedObject var viewModel: NoteViewModel
    
    @State private var showNewNote = false
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Folder Header
            HStack {
                Text(folder.name)
                    .font(.largeTitle.bold())
                Spacer()
                Button(action: { showNewNote = true }) {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .foregroundColor(.purple)
                }
            }
            .padding([.horizontal, .top])
            
            Divider()
            
            // MARK: Notes List
            if folder.notes.isEmpty {
                Spacer()
                VStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No notes yet")
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                List(folder.notes) { note in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title)
                            .font(.headline)
                        Text(note.content)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
        }
        .sheet(isPresented: $showNewNote) {
            newNoteSheet
        }
    }
    
    // MARK: - New Note Sheet
    private var newNoteSheet: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Note title", text: $newNoteTitle)
                }
                
                Section(header: Text("Content")) {
                    TextEditor(text: $newNoteContent)
                        .frame(height: 200)
                }
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showNewNote = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newNote = Note(title: newNoteTitle, content: newNoteContent)
                        if let index = viewModel.folders.firstIndex(where: { $0.id == folder.id }) {
                            viewModel.folders[index].notes.append(newNote)
                        }
                        showNewNote = false
                        newNoteTitle = ""
                        newNoteContent = ""
                    }
                    .disabled(newNoteTitle.isEmpty)
                }
            }
        }
    }
}
