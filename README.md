# Anki Clone — Flutter Frontend

A cross-platform **flashcard learning application** inspired by [Anki](https://apps.ankiweb.net/), built with Flutter. It supports creating decks, notes, cards, and templates, along with spaced-repetition review sessions and self-testing — all backed by a local SQLite database.

## Features

- **Deck Management** — Create and browse decks of flashcards.
- **Note & Card Creation** — Add notes with customizable fields; cards are generated from note/card templates.
- **Templates** — Define reusable note templates and card templates to control what appears on each side of a card.
- **Tagging** — Organize notes with tags for easy filtering.
- **Spaced-Repetition Review** — Study cards using a learning scheduler that tracks per-card statistics and history.
- **Self-Testing Mode** — Configure and run test sessions against a deck to evaluate your knowledge.
- **Card Browser** — Browse, review, and manage all cards within a deck.
- **Offline-First** — All data is stored locally using SQLite; no internet connection required.
- **Cross-Platform** — Runs on Android, iOS, macOS, Linux, Windows, and Web.

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart SDK ≥ 3.3) |
| State Management | [flutter_bloc](https://pub.dev/packages/flutter_bloc) / [bloc](https://pub.dev/packages/bloc) |
| Local Storage | [sqflite](https://pub.dev/packages/sqflite) + [sqlite3_flutter_libs](https://pub.dev/packages/sqlite3_flutter_libs) |
| Equality | [equatable](https://pub.dev/packages/equatable) |
| Design System | Material 3 with `ColorScheme.fromSeed` |

## Project Structure

The project follows a **modular monorepo** pattern using local Dart packages under `packages/`:

```
.
├── lib/
│   └── main.dart              # App entry point & routing
├── packages/
│   ├── data/                  # Data layer
│   │   ├── data_api/          # Abstract data interfaces & domain models
│   │   ├── repos/             # Repository implementations (business logic)
│   │   └── sqlite_data/       # SQLite-backed concrete data source
│   └── ui/                    # Feature screens (each is a standalone package)
│       ├── add_new_card/
│       ├── add_new_template/
│       ├── card_browser/
│       ├── components/        # Shared UI components
│       ├── learning_screen/
│       ├── login_screen/
│       ├── main_screen/
│       ├── register_screen/
│       ├── testing_screen/
│       └── testing_setup/
├── test/                      # Unit & widget tests
├── android/                   # Android platform shell
├── ios/                       # iOS platform shell
├── macos/                     # macOS platform shell
├── linux/                     # Linux platform shell
├── windows/                   # Windows platform shell
└── web/                       # Web platform shell
```

### Architecture Overview

```
┌────────────────────────────────┐
│           UI Packages          │  (screens & widgets)
│  login · main · card_browser   │
│  learning · testing · ...      │
└──────────────┬─────────────────┘
               │ uses BLoC / RepositoryProvider
┌──────────────▼─────────────────┐
│          Repositories          │  (CardRepo, DeckRepo, NoteRepo, ...)
│        packages/data/repos     │
└──────────────┬─────────────────┘
               │ depends on abstract APIs
┌──────────────▼─────────────────┐
│          Data API              │  (interfaces + domain models)
│      packages/data/data_api    │
└──────────────┬─────────────────┘
               │ implemented by
┌──────────────▼─────────────────┐
│         SQLite Data            │  (concrete implementation)
│     packages/data/sqlite_data  │
└────────────────────────────────┘
```

### Domain Models

| Model | Description |
|---|---|
| `Deck` | A named collection of cards (id, name, description) |
| `Note` | A piece of knowledge linked to a note template |
| `NoteTemplate` | Defines the fields a note can have (e.g., "Front", "Back", "Extra") |
| `Card` | A reviewable unit linking a deck, note, and card template |
| `CardTemplate` | Controls how note fields map to card sides |
| `NoteTag` | Tags for organizing and filtering notes |
| `LearningStat` | Per-card review statistics and history |

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (≥ 3.3)
- A supported platform toolchain (Xcode for iOS/macOS, Android Studio for Android, etc.)

### Installation

```bash
# Clone the repository
git clone https://github.com/SAD-ppt/frontend.git
cd frontend

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Running on a Specific Platform

```bash
flutter run -d chrome      # Web
flutter run -d macos        # macOS
flutter run -d ios          # iOS Simulator
flutter run -d android      # Android Emulator
flutter run -d linux        # Linux
flutter run -d windows      # Windows
```

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m "Add my feature"`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a Pull Request

## License

This project does not currently specify a license. Please contact the repository maintainers for usage terms.
