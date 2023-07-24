# Tic-Tac-Toe!
iOS Tic Tac Toe app coded in Swift.

<p align="center">
  <img src="https://s3.amazonaws.com/asherchok.com/2023/ttt/Image+7-23-23+at+9.55+PM.jpg" width=30% height=30%>
  <img src="https://s3.amazonaws.com/asherchok.com/2023/ttt/Image+7-23-23+at+9.57+PM.jpg" width=30% height=30%>
  <img src="https://s3.amazonaws.com/asherchok.com/2023/ttt/Image+7-23-23+at+9.55+PM+(1).jpg" width=30% height=30%>
</p>



# Project Milestones
- 3X3 grid button with functional game winning/draw code
- Fixed a bug where user can interact with buttons during fading animation with
  ```button.isUserInteractionEnabled = false```
- Allow users to switch player icons on `TTTVC` view controller from `SettingsVC` toggle button
- Added animations to `MainVC` background (disabled and needs fixing)
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
- Applied OOP to further enhance code readability:
  - Create a `GameLogic` class  that encapsulates the game logic operations of the tic tac toe interface 
- Live Activities + DynamicIsland
