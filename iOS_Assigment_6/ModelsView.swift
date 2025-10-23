//
//  ModelsView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-22.
//

import Foundation
struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var dateCreated: Date

    init(id: UUID = UUID(), title: String = "", content: String = "", dateCreated: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.dateCreated = dateCreated
    }
}

struct Folder: Identifiable, Codable {
    let id: UUID
    var name: String
    var notes: [Note]
    var isDiary: Bool
    var password: String?

    init(id: UUID = UUID(), name: String, notes: [Note] = [], isDiary: Bool = false, password: String? = nil) {
        self.id = id
        self.name = name
        self.notes = notes
        self.isDiary = isDiary
        self.password = password
    }
}
