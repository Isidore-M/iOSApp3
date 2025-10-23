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
    @Published var quickNotes: [Note] = []

    init() {
        // sample data for preview/testing
        folders = [
            Folder(name: "All my notes"),
            Folder(name: "Mathematics Classes"),
            Folder(name: "Diary", isDiary: true, password: "1234")
        ]

        quickNotes = [
            Note(title: "Integer numbers", content: "Lorem ipsum dolor..."),
            Note(title: "Decimal numbers", content: "Lorem ipsum dolor...")
        ]
    }

    func createFolder(name: String, isDiary: Bool = false, password: String? = nil) {
        let newFolder = Folder(name: name, notes: [], isDiary: isDiary, password: password)
        folders.append(newFolder)
    }

    func addQuickNote(_ note: Note) {
        quickNotes.append(note)
    }

    func addNote(_ note: Note, to folderID: UUID) {
        guard let idx = folders.firstIndex(where: { $0.id == folderID }) else { return }
        folders[idx].notes.append(note)
    }
}
