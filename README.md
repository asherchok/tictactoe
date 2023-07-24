# Tic-Tac-Toe!
iOS Tic Tac Toe app coded in Swift.

# Project Milestones
- 3X3 grid button with functional game winning/draw code
- Fixed a bug where user can interact with buttons during fading animation with
  ```button.isUserInteractionEnabled = false```
- Fixed issues for player icons to not change from `SettingsVC` toggle button
- Applied OOP for code readability:
  - MainVC.swift
    - Moved functions from `MainVC` class to a new `MainMenuBackground` class
  - TTTVC.swift
    - Moved functions from `TTTVC` class to a new `GameResetManager` class
  

# Known Issues
- Locking portrait mode works <strong>only</strong> on `TTTVC.swift`: `var supportedInterfaceOrientations does` not work on `MainVC.swift` and `SettingsVC.swift`.
- Animations on `MainVC.swift` does not load up
- `UISegmentedControl` toggle button crashes app upon trigger
# Would like to work on
Lists below are not included in Known Issues section.
- Applied OOP to further enhance code readability:
  - Create a `GameLogic` class  that encapsulates the game logic operations of the tic tac toe interface 
- Live Activities + DynamicIsland
