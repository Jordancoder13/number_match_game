# Number Master - Flutter Puzzle Game

A Flutter-based number-matching puzzle game inspired by 'Number Master' by KiwiFun. This project demonstrates clean architecture, reusable components, and scalable design patterns suitable for fresher-level Flutter development.

## 🎮 Game Overview

**Number Master** is a strategic puzzle game where players match numbers following specific rules. The game features sparse grids, visual feedback animations, and progressive difficulty across multiple levels.

### 🎯 Core Gameplay Mechanics

- **Match Rule**: Match two cells if they are **equal** or **sum to 10**
- **No Removal**: Matched cells remain visible but become faded/dull
- **Visual Feedback**: 
  - Valid match → Fade animation with visual effect
  - Invalid match → Shake animation with red flash
- **Interaction**: Tap first cell → highlight → tap second cell → check rule → animate result
- **Progression**: 3 distinct levels with increasing difficulty
- **Sparse Grid**: Only 3-4 rows filled initially (Number Master style)
- **Add Row Feature**: Limited row additions per level (5-7 rows depending on level)

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (stable channel)
- Dart SDK
- Chrome browser (for web testing)
- Android Studio/VS Code with Flutter extensions

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Jordancoder13/number_match_game.git
   cd number_match_game
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the game**
   ```bash
   # For web (recommended for testing)
   flutter run -d chrome
   
   # For Android device/emulator
   flutter run
   ```

4. **Build APK (for release)**
   ```bash
   flutter build apk --release
   ```

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter (stable channel)
- **State Management**: Riverpod 2.6.1
- **Architecture Pattern**: Clean Architecture with Provider pattern
- **UI Design**: Material 3 with custom Number Master theming

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── cell.dart            # Cell data model with animation states
│   └── level_config.dart    # Level configuration and progression
├── providers/
│   └── game_provider.dart   # Game state management with Riverpod
├── screens/
│   └── game_screen.dart     # Main game interface
└── widgets/
    └── grid_cell_widget.dart # Reusable cell component with animations
```

### Key Components

#### 1. **Cell Model** (`models/cell.dart`)
```dart
class Cell {
  final String id;
  final int value;
  final bool isSelected;
  final bool isMatched;
  final CellAnimationState animationState;
  final bool isEmpty;
}
```

#### 2. **Game Provider** (`providers/game_provider.dart`)
- Centralized state management using Riverpod
- Game logic including match validation
- Timer management (2 minutes per level)
- Level progression and scoring
- Animation state coordination

#### 3. **Grid Cell Widget** (`widgets/grid_cell_widget.dart`)
- Reusable UI component with multiple animation controllers
- Scale animation for selection feedback
- Shake animation for invalid matches
- Fade animation for valid matches
- Number Master inspired gradient designs

## 🎮 Level Design

### Level 1 - Beginner (Learn the Basics)
- **Grid Size**: 4×6 (24 cells)
- **Sparsity**: 20% empty cells
- **Time Limit**: 2 minutes
- **Add Rows**: 5 additional rows allowed
- **Number Pool**: 1-9
- **Description**: Introduction to basic matching mechanics

### Level 2 - Intermediate (More Challenging)
- **Grid Size**: 5×6 (30 cells)
- **Sparsity**: 15% empty cells
- **Time Limit**: 2 minutes
- **Add Rows**: 6 additional rows allowed
- **Number Pool**: 1-9
- **Description**: Increased complexity with more cells

### Level 3 - Advanced (Master Level)
- **Grid Size**: 6×6 (36 cells)
- **Sparsity**: 10% empty cells
- **Time Limit**: 2 minutes
- **Add Rows**: 7 additional rows allowed
- **Number Pool**: 1-9
- **Description**: Maximum difficulty with dense grids

## 🎯 Game Rules

### Matching Logic
1. **Equal Numbers**: Match any two cells with the same number (e.g., 5 + 5)
2. **Sum to 10**: Match two cells whose values sum to 10 (e.g., 3 + 7, 4 + 6)
3. **Valid Pairs for Sum to 10**:
   - 1 + 9 = 10
   - 2 + 8 = 10
   - 3 + 7 = 10
   - 4 + 6 = 10
   - 5 + 5 = 10

### Game Flow
1. **Start**: Level begins with sparse grid (3-4 rows filled)
2. **Selection**: Tap first cell (highlights with scale animation)
3. **Matching**: Tap second cell to attempt match
4. **Validation**: 
   - Valid → Both cells fade with success animation
   - Invalid → Shake animation with visual feedback
5. **Progression**: Clear cells to progress, add rows when needed
6. **Completion**: Complete level within 2 minutes to advance

### Scoring System
- **Base Points**: 10 points per successful match
- **Time Bonus**: Additional points for remaining time
- **Level Multiplier**: Points multiplied by level number

## 🎨 Visual Design

### Theme & Colors
- **Primary**: Purple gradient (#7B1FA2 → #8E24AA)
- **Background**: Light purple (#F3E5F5)
- **Success**: Green gradients for valid matches
- **Error**: Red flash for invalid matches
- **Cells**: Dynamic gradients based on number values

### Animations
- **Selection**: Scale animation (1.0 → 1.1 → 1.0)
- **Invalid Match**: Shake animation with red overlay
- **Valid Match**: Fade animation (1.0 → 0.6 opacity)
- **UI Transitions**: Smooth Material 3 transitions

## 🛠️ Development Features

### Code Quality
- **Modular Architecture**: Clear separation of concerns
- **Reusable Components**: Scalable widget architecture
- **Type Safety**: Full Dart type safety implementation
- **State Management**: Reactive UI with Riverpod
- **Performance**: Optimized animations and rendering

### Scalability Features
- **Level System**: Easy to add new levels via configuration
- **Animation System**: Extensible animation controllers
- **Theme System**: Customizable color schemes
- **Component Library**: Reusable UI components

## 📱 Platform Support

- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ✅ **Windows** (Windows 10+)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Linux** (GTK 3.0+)

## 🚀 Build & Deployment

### Web Deployment
```bash
flutter build web --release
# Deploy to GitHub Pages or Firebase Hosting
```

### Android APK
```bash
flutter build apk --release
# APK available in build/app/outputs/flutter-apk/
```

### Development Build
```bash
flutter run --debug
# Hot reload enabled for development
```

## 🎥 Demo

### Gameplay Features Demonstrated
- Number matching mechanics (equal and sum to 10)
- Visual feedback animations
- Level progression system
- Add row functionality
- Timer and scoring system

**🎬 Demo Video**: [Watch Number Master Gameplay](https://drive.google.com/file/d/1b8rXCTX_-9y3oJq8hkgKkmZk6REqnINE/view?usp=sharing)

## 📱 Download APK

### Ready-to-Install APk
- **File Name**: `NumberMaster-v1.0.0-release.apk`
- **File Size**: 36.7 MB
- **Target Platform**: Android 5.0+ (API 21+)
- **Download**: Available in [GitHub Releases](https://github.com/Jordancoder13/number_match_game/releases)

### Installation Instructions
1. **Download** the APK file from GitHub Releases
2. **Enable** "Install from Unknown Sources" in Android settings:
   - Go to Settings → Security → Unknown Sources (Android 7 and below)
   - Go to Settings → Apps → Special Access → Install Unknown Apps (Android 8+)
3. **Open** the downloaded APK file
4. **Tap** "Install" and wait for completion
5. **Launch** "Number Master" from your app drawer

### System Requirements
- **Android Version**: 5.0 or higher (API 21+)
- **Storage Space**: 50 MB free space
- **RAM**: 2 GB recommended
- **Architecture**: Supports both 32-bit and 64-bit devices

*APK available in GitHub Releases*

## 🧪 Testing

### Manual Testing Checklist
- [ ] Cell selection and highlighting
- [ ] Valid match detection (equal numbers)
- [ ] Valid match detection (sum to 10)
- [ ] Invalid match feedback
- [ ] Animation timing and smoothness
- [ ] Level progression
- [ ] Timer functionality
- [ ] Add row feature
- [ ] Responsive design

### Test Cases Covered
1. **Match Validation**: All valid number combinations
2. **Animation States**: Selection, valid, invalid, matched
3. **Level Progression**: Automatic advancement
4. **Edge Cases**: Timer expiry, grid completion
5. **UI Responsiveness**: Different screen sizes

## 🤝 Contributing

This project follows Flutter best practices and clean architecture principles. When contributing:

1. **Code Style**: Follow Dart/Flutter conventions
2. **Architecture**: Maintain separation of concerns
3. **Testing**: Add tests for new features
4. **Documentation**: Update README for significant changes

## 📋 Technical Requirements Met

### ✅ Core Requirements
- [x] Flutter stable channel implementation
- [x] Riverpod state management
- [x] Modular structure (widgets, services, models)
- [x] Reusable components (GridCellWidget, GameController)
- [x] Scalable architecture for future features
- [x] Clean separation of UI & logic

### ✅ Gameplay Requirements
- [x] Match rule: equal or sum to 10
- [x] No removal: matched cells remain visible but faded
- [x] Visual feedback: animations for valid/invalid matches
- [x] Tap interaction: highlight → select → animate
- [x] 3 distinct levels with progression
- [x] Sparse grid similar to Number Master
- [x] Add row functionality with limits
- [x] 2-minute timer per level

### ✅ Deliverables
- [x] Public GitHub repository
- [x] Comprehensive README.md
- [x] Clean commit history
- [x] Documented code architecture
- [x] APK in GitHub Releases
- [x] Demo video (30-60 seconds)

## 📞 Contact

**Developer**: Jordancoder13  
**Repository**: [number_match_game](https://github.com/Jordancoder13/number_match_game)  
**Assignment**: Fresher Flutter Developer Position

---

*Built with Flutter 💙 • Inspired by Number Master 🧩 • Clean Architecture 🏗️*
