//
//  NoteViewModel.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-22.
//

import Foundation
import SwiftUI

final class NoteViewModel: ObservableObject {
    @Published var folders: [Folder] = []
    
    init() {
        // sample data for preview/testing
        folders = [
            Folder(name: "All my notes"),
            Folder(name: "Mathematics Classes"),
            Folder(name: "My Diary", isDiary: true, password: "1234")
        ]
    }

    // MARK: - Folder Management
    func createFolder(name: String, isDiary: Bool = false, password: String? = nil) {
        let newFolder = Folder(name: name, notes: [], isDiary: isDiary, password: password)
        folders.append(newFolder)
    }
    
    // MARK: - Quick Notes
    func addQuickNote(_ note: Note) {
        // Look for an existing "Quick Notes" folder
        if let index = folders.firstIndex(where: { $0.name == "Quick Notes" }) {
            folders[index].notes.append(note)
        } else {
            // Create the "Quick Notes" folder if it doesn't exist
            let quickNotesFolder = Folder(name: "Quick Notes", notes: [note])
            folders.insert(quickNotesFolder, at: 0) // insert at top
        }
    }
    
    // MARK: - Add Note to a Folder
    func addNote(_ note: Note, to folderID: UUID) {
        guard let idx = folders.firstIndex(where: { $0.id == folderID }) else { return }
        folders[idx].notes.append(note)
    }
}
