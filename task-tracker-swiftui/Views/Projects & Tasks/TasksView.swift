//
//  TasksView.swift
//  task-tracker-swiftui
//
//  Created by Andrew Morgan on 03/11/2020.
//

import SwiftUI
import RealmSwift

struct TasksView: View {
    @ObservedResults(Task.self, sortDescriptor: SortDescriptor(keyPath: "_id", ascending: true)) var tasks
    @EnvironmentObject var state: AppState

    let project: Project?
    @State var showingSheet = false

    var body: some View {
        List {
            ForEach(tasks) { task in
                TaskView(task: task)
            }
            .onDelete(perform: $tasks.remove)
        }
        .navigationBarTitle("Tasks in \(project?.name ?? "")", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: { self.showingSheet = true }) {
            Image(systemName: "plus.circle.fill")
                .renderingMode(.original)

        })
        .sheet(isPresented: $showingSheet) { AddTaskView(partition: project?.partition ??
                                                    "PUBLIC") }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        Realm.bootstrap()

        return AppearancePreviews(
            Group {
                NavigationView {
                    TasksView(project: .sample)
                }
                Landscape(
                    NavigationView {
                        TasksView(project: .sample)
                    }
                )
            }
        )
        .environmentObject(AppState())
    }
}
