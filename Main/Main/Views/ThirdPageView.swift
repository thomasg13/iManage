import SwiftUI

struct Book: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var startDate: String
    var isCompleted = false
    var pages: Double
    var pagesPerDay: Double
    var days: Double
    var journal: String = ""
    var progress: Double {
        return (pagesPerDay * days / pages)
    }
}

struct ThirdPageView: View {
    @Binding var books: [Book]
    @State private var toViewShelf: Bool = false
    @State private var isChecked: Bool = false
    @State private var lastCheckedDate: Date?

    var body: some View {
        ZStack {
            VStack {
                Text("Book Shelf")
                    .font(.system(size: 25))
                    .bold()
                    .foregroundStyle(.secondary)
                    .foregroundColor(.blue)
                    .background(.ultraThinMaterial)
                VStack {
                    HStack {
                        if let reading = books.first {
                            Text("Current: \(reading.name)")
                                .font(.system(size: 20))
                            Spacer()
                            ProgressView(value: reading.progress, total: 1)
                                .padding()
                                .accentColor(.purple)
                            Text("\((Int)((reading.progress) * 100))%")
                        }
                        Toggle(isOn: $isChecked) {
                            
                        }
                        Button(action: {
                            print("View Book Shelf")
                            toViewShelf.toggle()
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding(20)
                }
                .onChange(of: isChecked) { value in
                    if value {
                        incrementReadingValues()
                    }
                }
                .disabled(isChecked || !canCheckToday())

                if let reading = books.first {
                    JournalView(journal: $books[books.firstIndex(where: { $0.id == reading.id })!].journal)
                }
            }
            
        }
        .sheet(isPresented: $toViewShelf) {
            BookShelfView(books: $books)
        }
        .onAppear {
            checkIfCheckedToday()
        }
        
    }

    private func incrementReadingValues() {
        if var reading = books.first {
            reading.days += 1
            if let index = books.firstIndex(where: { $0.id == reading.id }) {
                books[index] = reading
            }
            lastCheckedDate = Date()
        }
    }

    private func canCheckToday() -> Bool {
        guard let lastChecked = lastCheckedDate else { return true }
        let calendar = Calendar.current
        return !calendar.isDateInToday(lastChecked)
    }

    private func checkIfCheckedToday() {
        if let lastChecked = lastCheckedDate {
            let calendar = Calendar.current
            if calendar.isDateInToday(lastChecked) {
                isChecked = true
            }
        }
    }
}

struct BookShelfView: View {
    @State private var addBook : Bool = false
    @Binding var books: [Book]
    @State private var selectedBook: Book?
    @State private var changeBook: Bool = false

    var body: some View {
        VStack {
            Text("Your Book Shelf")
                .font(.system(size: 25))
                .bold()
                .padding()
            Spacer()
            List(books) { book in
                BookRowView(book: book, changeBook: $changeBook, selectedBook: $selectedBook)
            }
            Spacer()
            Button(action: {
                addBook.toggle()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
        }
        .sheet(isPresented: $changeBook) {
            if let selected = selectedBook, let index = books.firstIndex(where: { $0.id == selected.id }) {
                //print("Presenting ModifyBookView for \(selectedBook.name)")
                ModifyBookView(book: $books[index], books: $books)
            } else {
                //print("No book selected")
                Text("No book selected")
            }
        }
        .sheet(isPresented: $addBook) {
            NewBookView(books: $books)
        }
    }
}
struct NewBookView: View {
    @Binding var books: [Book]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var startDate: String = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: Date())
    }()
    
    @State private var selectedDate: Date = Date()

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    @State private var pages: Double = 0
    @State private var pagesPerDay: Double = 0
    @State private var days: Double = 0

    var body: some View {
        VStack {
            Text("Add New Book")
                .font(.largeTitle)
                .padding()
            TextField("Book Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("Start Date")
//            TextField("Start Date", text: $startDate)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
            DatePicker("Start Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .onChange(of: selectedDate) { newDate in
                    startDate = dateFormatter.string(from: newDate)
                }
            Text("Total Pages")
            TextField("Pages", value: $pages, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("Pages Per Day")
            TextField("Pages per Day", value: $pagesPerDay, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                let newBook = Book(name: name, startDate: startDate, pages: pages, pagesPerDay: pagesPerDay, days: days)
                books.append(newBook)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Add Book")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
    }
}
struct ModifyBookView: View {
    @Binding var book: Book
    @Binding var books: [Book]
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedDate: Date = Date()

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }

    var body: some View {
        VStack {
            Text("\(book.name)")
                .font(.largeTitle)
                .padding()
            TextField("Book Name", text: $book.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            DatePicker("Start Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .onChange(of: selectedDate) { newDate in
                    book.startDate = dateFormatter.string(from: newDate)
                }
            Text("Total Pages: ")
            TextField("Pages", value: $book.pages, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("Pages Per Day")
            TextField("Pages per Day", value: $book.pagesPerDay, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                switchToFirstPosition()
            }) {
                Text("Set as Current Book")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .onAppear {
            if let date = dateFormatter.date(from: book.startDate) {
                selectedDate = date
            }
        }
    }

    private func switchToFirstPosition() {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            let selectedBook = books.remove(at: index)
            books.insert(selectedBook, at: 0)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct BookRowView: View {
    var book: Book
    @Binding var changeBook: Bool
    @Binding var selectedBook: Book?

    var body: some View {
        HStack {
            Text("\(book.name) Since: \(book.startDate)")
            ProgressView(value: book.progress, total: 1)
                .padding()
                .accentColor(.purple)
            Text("\((Int)((book.progress) * 100))%")
            Button(action: {
                selectedBook = book
                print("Selected Book: \(selectedBook?.name ?? "None")")
                
                changeBook.toggle()
            }) {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
        }
    }
}

struct JournalView: View {
    @Binding var journal: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("Journal")
                .font(.headline)
                .padding(.bottom, 5)
            TextEditor(text: $journal)
                .frame(height: 200)
                .border(Color.gray, width: 1)
                .padding(.bottom, 10)
        }
        .padding()
    }
}

