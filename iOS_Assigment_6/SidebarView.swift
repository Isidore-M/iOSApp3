//
//  SidebarView.swift
//  iOS_Assigment_6
//
//  Created by Eezy Mongo on 2025-10-22.
//
import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: NoteViewModel
    @Binding var selectedFolderID: UUID?
    @Binding var showCreateFolder: Bool
    
    var onFolderSelected: (Folder) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Be.note")
                    .font(.largeTitle).bold()
                    .foregroundColor(.orange)
                Text("create, write now and ever")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 24)

            VStack(spacing: 10) {
                ForEach(viewModel.folders) { folder in
                    Button {
                        onFolderSelected(folder)
                    } label: {
                        HStack {
                            Image(systemName: folder.isDiary ? "lock.folder" : "folder")
                            Text(folder.name)
                            Spacer()
                        }
                        .padding(10)
                        .background(selectedFolderID == folder.id ? Color.blue.opacity(0.14) : Color.clear)
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    selectedFolderID = nil
                } label: {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Quick note")
                        Spacer()
                    }
                    .padding(10)
                    .background(Color.blue.opacity(0.18))
                    .cornerRadius(10)
                }

                Button {
                    showCreateFolder = true
                } label: {
                    HStack {
                        Image(systemName: "plus.square")
                        Text("Add a new folder")
                        Spacer()
                    }
                    .padding(10)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.top, 8)
            }

            Spacer()

            Text("Be.Note 2025 all rights reserved")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
        }
        .frame(width: 260)
        .padding()
        .background(Color(UIColor.systemGray6))
    }
}
