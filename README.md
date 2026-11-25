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
