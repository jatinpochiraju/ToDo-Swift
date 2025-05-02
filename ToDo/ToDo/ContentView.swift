import SwiftUI

struct ContentView: View {
    @AppStorage("tasks") private var tasksData: Data = Data()
    @State private var tasks: [Task] = []
    @State private var newTask = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Greeting and Date
                VStack(alignment: .leading, spacing: 4) {
                    Text(greetingMessage())
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text(formattedDate())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                // Input Field
                HStack {
                    TextField("Enter a new task...", text: $newTask)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .foregroundColor(.primary)

                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal)

                // Task List
                List {
                    Section(header: Text("Tasks").foregroundColor(.primary)) {
                        ForEach(tasks) { task in
                            Text(task.title)
                                .foregroundColor(.primary)
                        }
                        .onDelete(perform: deleteTask)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("To Do")
            .background(Color(.systemBackground))
        }
        .onAppear(perform: loadTasks)
    }

    // MARK: - Helper Functions

    func greetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning ☀️"
        case 12..<17: return "Good Afternoon 🌤"
        case 17..<21: return "Good Evening 🌇"
        default: return "Good Night 🌙"
        }
    }

    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }

    func addTask() {
        guard !newTask.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let task = Task(title: newTask)
        tasks.append(task)
        newTask = ""
        saveTasks()
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }

    func loadTasks() {
        if let loadedTasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
            tasks = loadedTasks
        }
    }

    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            tasksData = encoded
        }
    }
}
