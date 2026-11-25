📚 Book Reading Tracker

An iPhone app built with Swift and SwiftUI for tracking the books you read. It is protected by Face ID, supports login and registration, and shows your reading progress on a dashboard, in a card list, a cover grid and a bookshelf.

Project 18 – Book Reading Tracker (iOS, SwiftUI, MVVM)

Screenshots

Each screenshot shows one requirement of the project.

1. Authentication (Face ID, Login, Register)
Register	Face ID unlock	Login (fallback)
Register	Face ID	Login
2. Dashboard
Dashboard	Dashboard (dark mode)
Dashboard	Dark mode
3. Book List (cards, covers, shelf)
Card list	Cover grid	Bookshelf
List	Grid	Shelf
4 to 7. Add, Details, Edit, Delete
Add Book	Book Details	Edit Book	Delete confirmation
Add	Details	Edit	Delete
8. Search and Filter
Search	Genre filter
Search	Filter
9. Reading Progress Tracking
Progress update
Progress
Features
#	Feature	Description
1	Face ID, Login and Register	Face ID unlocks the app at launch. If it is unavailable or fails, users log in with email and password. New users register with name, email, password and confirm password, all with validation.
2	Dashboard	Greeting, reading overview, total books, books finished, books being read, total pages read, a yearly reading goal ring, quick "+10 / +25 pages" logging and recently added books.
3	Book List	Scrollable cards showing cover, title, author, genre and a progress bar. Also available as a cover grid and a wooden bookshelf view.
4	Add Book	Title, author, genre, total pages and notes. The new book appears in the list immediately.
5	Book Details	Author, genre, total pages, pages read, progress percentage, status and personal notes.
6	Edit Book	Update the title, author, genre, pages and notes.
7	Delete Book	Swipe in the list, long-press in the grid, or use the delete button on the details screen (with confirmation).
8	Search and Filter	Search by title or author. Filter by genre and by status.
9	Progress Tracking	Slider and quick buttons update the progress bar and percentage instantly. Status changes automatically: Want to Read → Reading → Finished.

Extras: light and dark mode, lavender/purple theme, per-user shelves, lock and sign-out menu, generated book covers (no large images), custom app icon.

Tech Stack
Language: Swift 5
UI: SwiftUI (NavigationStack, TabView, List, LazyVGrid)
Architecture: MVVM
State management: @StateObject, @EnvironmentObject, @Published, @State
Biometrics: LocalAuthentication (Face ID)
Storage: JSON files in the Documents folder (books) and UserDefaults (accounts, goal)
Hashing: CryptoKit (salted SHA-256 for passwords)
Platform: iPhone only, portrait, iOS 17+
Project Structure
BookReadingTracker/
├── App/             BookReadingTrackerApp, RootView, MainTabView
├── Models/          UserAccount, Book, BookGenre, ReadingStatus, ReadingStats, Book+Samples
├── ViewModels/      AuthViewModel, BookStore, BookListViewModel,
│                    BookFormViewModel, DashboardViewModel
├── Services/        BiometricAuthService, AccountStorageService,
│                    BookStorageService, PasswordHasher
├── Views/
│   ├── Auth/        LoginView (Face ID, login, register)
│   ├── Dashboard/   DashboardView, GoalEditorView
│   ├── BookList/    BookListView, BookGridView, BookShelfView
│   ├── BookDetail/  BookDetailView
│   ├── BookForm/    BookFormView (add and edit)
│   └── Components/  BookCardView, BookCoverView, StatCardView, GoalRingView,
│                    ProgressBarView, StatusBadge, FilterChip, CardStyle, button styles
├── Utilities/       Theme (colours, fonts, layout), Validators
└── Assets.xcassets  AppIcon, AccentColor, EmptyShelf

Each feature is split into separate files for the UI (Views), data (Models), and business logic (ViewModels and Services).

Getting Started

Requirements: a Mac with Xcode 16 or later.

Clone the repository:
bash
git clone https://github.com/YOUR-USERNAME/BookReadingTracker.git
Open BookReadingTracker.xcodeproj in Xcode.
Select an iPhone simulator and press Run (⌘R).

To run on a real iPhone, choose your Team under Signing & Capabilities and change the bundle identifier (com.example.BookReadingTracker) to a unique one.

Testing Face ID in the simulator
Choose Features ▸ Face ID ▸ Enrolled.
When the prompt appears, choose Features ▸ Face ID ▸ Matching Face to succeed, or Non-matching Face to see the password login fallback.
First use
Register an account (name, valid email, password of 6+ characters).
Add books, update pages read, and watch the dashboard update.
Close and reopen the app to see Face ID unlock your shelf.
Notes
Accounts and books are stored only on the device; there is no server. Passwords are saved as salted hashes, never as plain text.
Each account has its own shelf. New accounts start with five sample books that can be deleted.
The app locks when it goes to the background.

# Book Reading Tracker (Project 18)

SwiftUI + MVVM iPhone app (portrait). Tracks books, reading progress and notes, locked behind Face ID.

## Open and run
1. Requires **Xcode 16 or later** (the project uses folder-synchronized groups, so every file inside `BookReadingTracker/` is picked up automatically).
2. Double-click `BookReadingTracker.xcodeproj`.
3. Choose an iPhone simulator and press **Run (⌘R)**.
4. Face ID on the simulator: **Features ▸ Face ID ▸ Enrolled**, then **Features ▸ Face ID ▸ Matching Face** when prompted. If Face ID is not enrolled, the app falls back to email login automatically.
5. Running on a real iPhone: select your Team under *Signing & Capabilities* and change the bundle identifier (`com.example.BookReadingTracker`) to something unique.

Accounts are local to the device. First launch shows **Register** (name, valid email, password of 6+ characters, confirm password). After that, **Face ID** unlocks the last signed-in user; if Face ID is unavailable or fails you log in with email + password. Each account has its own shelf. Passwords are stored only as salted hashes. Use the account menu on the dashboard to lock or sign out.

## Folder structure
```
BookReadingTracker/
├── App/            BookReadingTrackerApp, RootView (auth gate), MainTabView
├── Models/         UserAccount, Book, BookGenre, ReadingStatus, ReadingStats, Book+Samples
├── ViewModels/     AuthViewModel, BookStore, BookListViewModel, BookFormViewModel, DashboardViewModel
├── Services/       BiometricAuthService (Face ID), AccountStorageService, PasswordHasher, BookStorageService (JSON file)
├── Views/
│   ├── Auth/       LoginView
│   ├── Dashboard/  DashboardView, GoalEditorView
│   ├── BookList/   BookListView (list / cover grid / shelf), BookGridView, BookShelfView
│   ├── BookDetail/ BookDetailView
│   ├── BookForm/   BookFormView (Add + Edit)
│   └── Components/ BookCardView, BookCoverView (+ spine), StatCardView, GoalRingView, ProgressBarView, StatusBadge, FilterChip, CardStyle, button styles
├── Utilities/      Theme (lavender/purple palette, light + dark), Validators
└── Assets.xcassets AppIcon, AccentColor, EmptyShelf (small thumbnail)
```

## Feature checklist
| # | Feature | Where |
|---|---------|-------|
| 1 | Face ID at launch + login / register fallback with validation | `BiometricAuthService`, `AuthViewModel`, `AccountStorageService`, `PasswordHasher`, `LoginView` |
| 2 | Dashboard (total, finished, reading, pages read) + greeting, yearly goal ring, quick +10/+25 page logging | `DashboardView`, `DashboardViewModel`, `ReadingStats` |
| 3 | Book list cards with progress bar (also cover grid and bookshelf layouts) | `BookListView`, `BookCardView`, `BookGridView`, `BookShelfView` |
| 4 | Add book | `BookFormView` (`.add`), `BookFormViewModel` |
| 5 | Book details | `BookDetailView` |
| 6 | Edit book | `BookFormView` (`.edit`) |
| 7 | Delete book | swipe in list, trash button in details |
| 8 | Search (title/author) and genre/status filters | `BookListViewModel`, `BookListView` |
| 9 | Progress tracking, auto status | slider + quick buttons in `BookDetailView`, `Book.status` |

Data is saved to `books.json` in the app's Documents folder and survives relaunches.
