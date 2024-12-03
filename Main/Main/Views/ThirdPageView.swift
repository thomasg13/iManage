import SwiftUI

struct Book: Identifiable, Equatable {
	let id = UUID()
	var name: String
	var startDate: String
	var pages: Double
	var pagesRead : Double
	var progress: Double {
		return (pagesRead / pages)
	}
}

struct ThirdPageView: View {
	@Binding var books: [Book]
	@Binding var Journals: [journal]
	@State private var toViewShelf: Bool = false
	@State private var showPomodoro: Bool = false // State for Pomodoro timer

	var body: some View {
		ZStack {
			VStack {
				Spacer()
				Spacer()
				Spacer()
				Spacer()
				Text("Book Shelf")
					.font(Font.custom("Borel-Regular", size: 40))
					.bold()
					.foregroundStyle(.secondary)
					.foregroundColor(.black)
					.padding(5)
				BooksView(books: $books, toViewShelf: $toViewShelf)
				JournalView(Journals: $Journals)
				Spacer()
				HStack {
					Spacer()
					Button(action: {
						showPomodoro = true
					}) {
						Image(systemName: "timer")
							.font(.system(size: 25))
							.foregroundColor(.white)
							.padding()
							.background(Color.red)
							.clipShape(Circle())
							.shadow(radius: 5)
					}
					.padding()
					.offset(y: -40)
				}
			}

			// Floating Button for Pomodoro Timer
		}
		.sheet(isPresented: $toViewShelf) {
			BookShelfView(books: $books)
		}
		.sheet(isPresented: $showPomodoro) {
			PomodoroTimerView() // Present Pomodoro Timer
		}
	}
}

struct BooksView : View {
	@Binding var books: [Book]
	@Binding var toViewShelf: Bool
	var body : some View {
		HStack {
			BooksFrontView(books: $books)
			Button(action: {
				print("View Book Shelf")
				toViewShelf=true
			}) {
				Image(systemName: "arrow.right.circle.fill")
					.foregroundColor(.white)
					.frame(width: 30, height: 30)
					.background(Color.blue)
					.clipShape(Circle())
					.shadow(radius: 5)
			}
			.offset(y: -40)
		}
		.padding(20)
	}
}
struct BooksFrontView : View {
	@Binding var books: [Book]
	var body : some View {
		ForEach(books.prefix(2), id: \.id) { book in
			VStack {
				ZStack {
					Image(.cover)
						.resizable()
						.scaledToFit()
						.frame(width: 150, height: 200)
						.border(Color.gray, width: 2)
					Text(book.name)
						.font(Font.custom("Borel-Regular", size: 25))
				}
				HStack {
					ProgressView(value: book.progress, total: 1)
						.padding()
						.accentColor(.purple)
						.scaleEffect(x: 1, y: 3)
					Text("\((Int)(book.progress * 100))%")
						.font(Font.custom("Borel-Regular", size: 20))
				}
				.padding(10)
			}
		}
	}
}
struct BookShelfView: View {
	@State private var addBook : Bool = false
	@Binding var books: [Book]
	@State private var selectedBook: Book?
	@State private var changeBook: Bool = true

	var body: some View {
		VStack {
			Text("Your Book Shelf")
				.font(Font.custom("Borel-Regular", size: 25))
				.bold()
				.padding()
			Spacer()
			List(books) { book in
				BookRowView(book: book, changeBook: $changeBook, selectedBook: $selectedBook, books: $books)
			}
			Spacer()
			Button(action: {
				addBook=true
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
				ModifyBookView(book: $books[index], books: $books)
			} else {
				Text("Here you can edit your book and/or update your reading progress (Swipe to the left)")
					.font(Font.custom("Borel-Regular", size: 40))
					.bold()
					.foregroundStyle(.secondary)
					.foregroundColor(.black)
					.padding(5)
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
	@State private var pagesRead: Double = 0
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
			Text("Pages Read")
			TextField("Pages Read", value: $pagesRead, formatter: NumberFormatter())
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding()
			Button(action: {
				let newBook = Book(name: name, startDate: startDate, pages: pages, pagesRead: pagesRead)
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
			
			Spacer()
			Text("PagesRead")
			TextField("Pages Read", value: $book.pagesRead, formatter: NumberFormatter())
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
	@Binding var books : [Book]

	var body: some View {
		HStack {
			Text("\(book.name) Since: \(book.startDate)")
			ProgressView(value: book.progress, total: 1)
				.padding()
				.accentColor(.purple)
			Text("\((Int)((book.progress) * 100))%")
		}.swipeActions {
			Button(action: {
				selectedBook = book
				print("Selected Book: \(selectedBook?.name ?? "None")")
				changeBook.toggle()
			}) {
				Label("Edit", systemImage: "pencil")
			}
			.tint(.blue)
			Button(role: .destructive) {
				deleteBook(book)
			} label: {
				Label("Delete", systemImage: "trash")
			}
		}
	}
	private func deleteBook(_ book: Book) {
		books.removeAll { $0.id == book.id }
	}
}

struct JournalView: View {
	
	@State private var isAddingJournal = false
	@Binding var Journals: [journal]
	var body: some View {
		VStack() {
			Text("Journal")
				.font(Font.custom("Borel-Regular", size: 40))
				.bold()
				.foregroundStyle(.secondary)
				.foregroundColor(.black)
				.background(.ultraThinMaterial)
				.padding(5)
			Button(action: {
				isAddingJournal.toggle()
			}) {
				Image(systemName: "book")
					.foregroundColor(.white)
					.frame(width: 200, height: 60)
					.background(Color.blue)
					.clipShape(.capsule)
					.shadow(radius: 5)
					.padding()
			}
			
			.sheet(isPresented: $isAddingJournal) {
				JournalNoteView(Journals: $Journals)
			}
		}
		.padding()
	}
}

struct journal: Identifiable {
	let id = UUID()
	var title: String
	var date: String //FIXME: just added this date param
	var note: String
}

struct JournalNoteView: View {
	@Binding var Journals: [journal]
	@State private var isAddingJournal = false
	@State private var JournalBeingEdited: journal? = nil
	
	var body: some View {
		VStack(spacing: 16) {
			VStack(alignment: .leading, spacing: 12) {
				Text("Journal")
					.font(.largeTitle)
					.bold()
					.padding(.top, 20)
			}
			
			List {
				ForEach(Journals) { journal in
					HStack {
						Capsule(style: RoundedCornerStyle.continuous)
							.fill(.blue)
							.frame(width: 10, height: .infinity)
							
						VStack(alignment: .leading) {
							VStack {
								Text(journal.title)
									.font(.headline)
								Text(journal.date)
								Text(journal.note)
							}
						}
						Spacer()
					}
						
					.padding()
					.frame(maxWidth: .infinity)
					.cornerRadius(8)
					.swipeActions {
						Button(role: .destructive) {
							deleteJournal(journal)
						} label: {
							Label("Delete", systemImage: "trash")
						}
					
						Button {
							editJournal(journal)
						} label: {
							Label("Edit", systemImage: "pencil")
						}
						.tint(.blue)
					}
				}
			}
				.listStyle(.sidebar)
				.sheet(item: $JournalBeingEdited) { journal in
					EditJournalView(journal: $Journals[Journals.firstIndex(where: { $0.id == journal.id })!])
				}
		}
		
		.background(Color(UIColor.systemGroupedBackground))
		.overlay(
			VStack {
				Spacer()
				HStack {
					Spacer()
					Button(action: {
						isAddingJournal=true
					}) {
						Image(systemName: "plus")
							.foregroundColor(.white)
							.frame(width: 60, height: 60)
							.background(Color.blue)
							.clipShape(Circle())
							.shadow(radius: 5)
							.padding()
					}
				}
			}
		)
		.sheet(isPresented: $isAddingJournal) {
			AddJournalView(isPresented: $isAddingJournal, Journals: $Journals)
		}
		
		}
	
	
	private func deleteJournal(_ journal: journal) {
		Journals.removeAll { $0.id == journal.id }
	}

	private func editJournal(_ journal: journal) {
		print("Edit Journal: \(journal.title)")
		JournalBeingEdited = journal
	}

	struct AddJournalView: View {
		@Binding var isPresented: Bool
		@Binding var Journals: [journal]
		@State private var journalTitle = ""
		@State private var journalNote = ""
		@State private var selectedDate: Date = Date()
		@State private var journalDate: String = {
				let formatter = DateFormatter()
				formatter.dateStyle = .short
				return formatter.string(from: Date())
			}()
		private var dateFormatter: DateFormatter {
				let formatter = DateFormatter()
				formatter.dateStyle = .short
				return formatter
			}
		var body: some View {
			NavigationView {
				Form {
					TextField("Journal Title", text: $journalTitle)
					DatePicker("Start Date", selection: $selectedDate, displayedComponents: .date)
									.datePickerStyle(GraphicalDatePickerStyle())
									.padding()
									.onChange(of: selectedDate) { newDate in
										journalDate = dateFormatter.string(from: newDate)
									}
					
					TextEditor(text: $journalNote)
									.frame(height: 200)
									.border(Color.gray, width: 1)
									.padding(.bottom, 10)
				}
				.navigationTitle("Add New Journal Entry")
				.toolbar {
					ToolbarItem(placement: .cancellationAction) {
						Button("Cancel") {
							isPresented = false
						}
					}
					ToolbarItem(placement: .confirmationAction) {
						Button("Save") {
							let newJournal = journal(title: journalTitle, date: journalDate, note: journalNote)
							Journals.append(newJournal)
							isPresented = false
						}
						.disabled(journalTitle.isEmpty)
					}
				}
			}
		}
	}
	
	
	struct EditJournalView: View {
		@Binding var journal: journal
		@Environment(\.dismiss) private var dismiss
		@State private var selectedDate: Date = Date()
		@State private var journalDate: String = {
				let formatter = DateFormatter()
				formatter.dateStyle = .short
				return formatter.string(from: Date())
			}()
		private var dateFormatter: DateFormatter {
				let formatter = DateFormatter()
				formatter.dateStyle = .short
				return formatter
			}
		var body: some View {
			NavigationView {
				Form {
					TextField("Journal Title", text: $journal.title)
					DatePicker("Start Date", selection: $selectedDate, displayedComponents: .date)
									.datePickerStyle(GraphicalDatePickerStyle())
									.padding()
									.onChange(of: selectedDate) { newDate in
										journal.date = dateFormatter.string(from: newDate)
									}
					TextEditor(text: $journal.note)
									.frame(height: 200)
									.border(Color.gray, width: 1)
									.padding(.bottom, 10)
				}
				.navigationTitle("Edit Task")
				.toolbar {
					ToolbarItem(placement: .confirmationAction) {
						Button("Done") {
							dismiss()
						}
					}
				}
			}
		}
	}

}

#Preview {
	@State var books: [Book] = [
		Book(name: "The Great Gatsby", startDate: "2024-11-27", pages: 300, pagesRead:100),
		Book(name: "Magic Mountain", startDate: "2024-11-28", pages: 300, pagesRead:100)
	]
	@State var Journals : [journal] = [
		journal(title: "First Journal", date: "", note: "This is the first journal entry")
	]
	return ThirdPageView(books: $books, Journals: $Journals)
}

