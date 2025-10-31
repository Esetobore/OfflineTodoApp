# Task Manager - Flutter Mobile Application

A clean and efficient task management application built with Flutter, demonstrating Domain-Driven Design (DDD) architecture, Riverpod state management, and SQLite local persistence.

## 📱 App Description

Task Manager is a simple yet powerful mobile application that helps users organize their daily tasks. The app allows users to create, edit, delete, and search tasks with a clean and intuitive interface. All data persists locally using SQLite, ensuring tasks are available even when offline.

### Key Features
- ✅ Create new tasks with title and description
- ✅ Edit existing tasks
- ✅ Toggle task completion status with a single tap
- ✅ Delete tasks with confirmation dialog
- ✅ Real-time search functionality
- ✅ Persistent local storage using SQLite
- ✅ Empty state UI when no tasks exist
- ✅ Pull-to-refresh functionality
- ✅ Error handling with user-friendly messages
- ✅ Responsive and material design UI

## 🏗️ Architecture

This project follows **Domain-Driven Design (DDD)** principles with clear separation of concerns across four main layers:

### Layer Structure

```
lib/
├── domain/              # Business logic (pure Dart)
│   ├── entities/       # Task entity
│   └── repositories/   # Repository interfaces
├── data/                # External dependencies
│   ├── datasource/       # SQLite database helper
│   └── repositories/   # Repository implementations
└── presentation/        # UI layer
    ├── providers/      # Riverpod providers & state management
    ├── screens/        # App screens
    └── widgets/        # Reusable widgets
```

## 🎯 State Management Approach

This application uses **Riverpod** for state management, implementing the following pattern:

### Providers Used

1. **taskRepositoryProvider** - Provides repository instance
2. **searchQueryProvider** - Manages search query state
3. **taskListProvider** - Manages task list state with AsyncValue
4. **filteredTaskListProvider** - Provides filtered tasks based on search

## 🗄️ Local Storage

**SQLite (via sqflite package)** is used for persistent local storage.

### Database Schema

```sql
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  isCompleted INTEGER NOT NULL,
  createdAt TEXT NOT NULL
)
```

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.9  # State management
  sqflite: ^2.3.0           # Local database
  path: ^1.8.3              # Path manipulation
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd task_manager
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Building APK

**Debug APK**
```bash
flutter build apk --debug
```

**Release APK**
```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk` or via the github release window

## 🧪 Testing Scenarios

### Manual Testing Checklist

- [ ] Create a new task
- [ ] Edit an existing task
- [ ] Toggle task completion
- [ ] Delete a task (with confirmation)
- [ ] Search for tasks
- [ ] Clear search
- [ ] Test with empty state
- [ ] Test with 10+ tasks
- [ ] Close and reopen app (test persistence)
- [ ] Pull to refresh
- [ ] Test form validation

## 💭 Challenges & Solutions

### Challenge 1: Data Persistence
**Problem**: Ensuring data persists across app restarts
**Solution**: Implemented SQLite with proper database initialization and migration support

### Challenge 2: Search Performance
**Problem**: Searching task lists
**Solution**: Implemented database-level search using SQL LIKE queries for optimal performance


## 📊 Time Estimation

| Task                      | Estimated Time |
|---------------------------|----------------|
| Project Setup & Architecture | 30 minutes     |
| Domain Layer Implementation | 1 hour         |
| Data Layer (DB & Repo)    | 1.5 hours      |
| Presentation Layer        | 3.5 hours      |
| Testing & Bug Fixes       | 1.5 hours      |
| Documentation             | 1 hour         |
| **Total**                 | **~8 hours**   |
