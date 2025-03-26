import SwiftUI

struct HatchNotesView: View {
    @ObservedObject var hatch: Hatch
    @State private var showingAddNote = false
    @State private var newNote = ""
    
    var body: some View {
        List {
            Section {
                if hatch.notes.isEmpty {
                    Text("No notes yet")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(hatch.notes) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.value)
                                .font(.body)
                            Text(note.timestamp, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Section {
                Button(action: { showingAddNote = true }) {
                    Label("Add Note", systemImage: "plus.circle.fill")
                }
            }
        }
        .navigationTitle("Notes")
        .sheet(isPresented: $showingAddNote) {
            NavigationView {
                Form {
                    Section {
                        TextEditor(text: $newNote)
                            .frame(height: 100)
                    }
                }
                .navigationTitle("New Note")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showingAddNote = false
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if !newNote.isEmpty {
                                hatch.addLog(newNote)
                                newNote = ""
                                showingAddNote = false
                            }
                        }
                        .disabled(newNote.isEmpty)
                    }
                }
            }
        }
    }
}

//struct LogEntry: Identifiable, Codable {
//    let id = UUID()
//    let value: String
//    let timestamp: Date
//} 
