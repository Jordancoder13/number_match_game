# Number Match Game

A Flutter-based number matching puzzle game inspired by 'Number Master' by KiwiFun. Match numbers that are equal or sum to 10 to clear the board!

## Game Features

### Core Gameplay
- **Match Rule**: Connect two cells if their numbers are equal OR sum to 10
- **Visual Feedback**: Selected cells highlight with blue glow, matched cells fade to grey
- **Progressive Difficulty**: 3 levels with increasing grid size and decreasing time limits
- **Timer Challenge**: Complete each level within the time limit (2 minutes for Level 1, decreasing for higher levels)
- **Dynamic Grid**: Start with 3-5 rows, add more rows as needed with the "Add Row" button

### Game Mechanics
- **Level 1**: 3 rows, 2 minutes
- **Level 2**: 4 rows, 1 minute 40 seconds  
- **Level 3**: 5 rows, 1 minute 30 seconds
- **Scoring**: 10 points per match + time bonus on level completion
- **Grid Size**: 6 columns fixed, rows vary by level

### Technical Features
- Built with **Flutter** and **Riverpod** for state management
- Responsive design that works on web, desktop, and mobile
- Smooth animations and visual feedback
- Clean, modular architecture

## How to Play

1. **Select** two cells by tapping them
2. **Match** numbers that are:
   - Exactly equal (e.g., 5 and 5)
   - Sum to 10 (e.g., 3 and 7, 4 and 6)
3. **Clear** all cells to complete the level
4. **Add rows** if you need more numbers to create matches
5. **Complete** each level before time runs out!

## Getting Started

### Prerequisites
- Flutter SDK (3.32.8 or later)
- VS Code with Flutter extension
- Chrome browser (for web development)

### Installation & Running

1. **Clone/Download** this project
2. **Navigate** to the project directory:
   ```bash
   cd number_match_game
   ```

3. **Get dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   - For web: `flutter run -d chrome`
   - For desktop: `flutter run -d windows` (requires Visual Studio)
   - For Android: `flutter run -d android` (requires Android Studio)

### Development Commands

- **Hot Reload**: Press `r` in the terminal while app is running
- **Hot Restart**: Press `R` in the terminal while app is running
- **Quit**: Press `q` in the terminal

## Project Structure

```
lib/
├── main.dart                 # App entry point with Riverpod setup
├── models/
│   ├── cell.dart            # Cell data model
│   └── level_config.dart    # Level configuration
├── providers/
│   └── game_provider.dart   # Game state management (Riverpod)
├── screens/
│   └── game_screen.dart     # Main game UI
└── widgets/
    └── grid_cell_widget.dart # Individual cell widget
```

## Architecture

- **State Management**: Riverpod StateNotifier pattern
- **Models**: Immutable data classes with copyWith methods
- **UI Components**: Reusable, animated widgets
- **Game Logic**: Separated from UI in providers
- **Levels**: Configurable difficulty system

## Building for Production

### Web
```bash
flutter build web --release
```
The built files will be in `build/web/`

### Android APK
```bash
flutter build apk --release
```
The APK will be in `build/app/outputs/flutter-apk/`

### Windows Desktop
```bash
flutter build windows --release
```
The executable will be in `build/windows/runner/Release/`

## Code Quality

- Uses Flutter 3.x with Material 3 design
- Follows Dart/Flutter linting rules
- Modular, testable architecture
- Clean separation of concerns
- Type-safe state management

## Future Enhancements

Potential improvements for the future:
- Sound effects and music
- Particle effects for matches
- Multiple themes/skins
- Leaderboards and achievements
- More complex level types
- Hint system
- Undo functionality

## Development Notes

### Key Design Decisions
1. **Riverpod** for state management - provides excellent developer experience and testability
2. **Immutable state** with copyWith methods - ensures predictable state updates
3. **Weighted number generation** - ensures playable boards with matching opportunities
4. **Configurable levels** - easy to add new levels and adjust difficulty
5. **Animation-rich UI** - provides satisfying user feedback

### Performance Considerations
- Efficient GridView rendering
- Minimal state updates
- Proper widget lifecycle management
- Optimized hot reload support

---

Enjoy playing Number Match! 🎮✨
