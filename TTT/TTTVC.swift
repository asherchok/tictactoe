//
//  TTTVC.swift
//  TTT
//
//  Created by Asher Chok on 6/24/23.
//

import UIKit


class TTTVC: UIViewController, SettingsVCDelegate {
    func didUpdateAnimationStatus(_ status: Bool) {
        //..
    }
    
    @IBOutlet weak var player2Lbl: UILabel!
    @IBOutlet weak var player1Lbl: UILabel!
    @IBAction func returnButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var gameBoard: [UIButton]!
    @IBOutlet weak var gameWinStateLabel: UILabel!
    @IBOutlet weak var gameStateLabel: UILabel!
    
    //gameScoreBoard
    @IBOutlet weak var scorePlayer1Label: UILabel!
    @IBOutlet weak var scorePlayer2Label: UILabel!
    
    var scorePlayer1 = 0
    var scorePlayer2 = 0
    
    var player1: String = "O" //generalize the characters
    var player2: String = "X"
    var currentPlayer: String = ""
    var gameBoardState: [String] = Array(repeating: " ", count: 9)
    
    // reset button manager class
    var gameResetManager = GameResetManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player1Lbl.text = player1
        player2Lbl.text = player2
        currentPlayer = player1 //let player1 always start in game but take on any str values other than X or O
        gameStateLabel.text = "\(player1) starts"
        updateGameScoreBoard()
        gameWinStateLabel.alpha = 0 //gamewinstate is invisible at start
        
        // Configure buttons appearance
        for button in gameBoard {
            button.layer.cornerRadius = 30
            button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
            button.addTarget(self, action: #selector(gameBoardButtonTapped(_:)), for: .touchUpInside)
        }
        
    }
    
    //storyboard logic
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait // lock orientation to only show portrait
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsVCID" {
            if let settingsVC = segue.destination as? SettingsVC {
                settingsVC.delegate = self
            }
        }
    }
    
    @objc func gameBoardButtonTapped(_ sender: UIButton) {
        guard let buttonIndex = gameBoard.firstIndex(of: sender) else {
            return
        }
        
        if gameBoardState[buttonIndex] == " " {
            gameBoardState[buttonIndex] = currentPlayer
            sender.setTitle(currentPlayer, for: .normal)
            checkForWin()
            currentPlayer = (currentPlayer == player1) ? player2 : player1
            gameStateLabel.text = "\(currentPlayer)'s turn"
        }
    }
    
    func didUpdatePlayerSymbols(player1: String, player2: String) {
        print("TTTVC: Received player symbols update to \(player1) and \(player2)") //debug
        self.player1 = player1
        self.player2 = player2
        currentPlayer = player1
        if gameStateLabel != nil {
            gameStateLabel.text = "\(currentPlayer) starts"
        }
    }
    
    func didSelectPlayerOption(player1: String, player2: String) {
        self.player1 = player1
        self.player2 = player2
        currentPlayer = player1
        gameStateLabel.text = "\(currentPlayer) starts"
    }
    
    // win conditions
    
    func checkForWin() {
        // define the winning combinations
        let winCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
            [0, 4, 8], [2, 4, 6] // diagonals
        ]
        
        for combination in winCombinations {
            let positions = combination.map { gameBoardState[$0] }
            if positions == [player2, player2, player2] {
                scorePlayer2 += 1
                nextGameWinSequence()
                return
            } else if positions == [player1, player1, player1] {
                scorePlayer1 += 1
                nextGameWinSequence()
                return
            }
        }
        
        // check for a draw
        if gameBoardState.allSatisfy({ $0 != " " }) {
            showGameWinState("Draw", color: .red)
            resetGameBoardOnNextRound()
        }
    }
    
    // on player WIN/DRAW
    
    func nextGameWinSequence() {  // do this when win
        updateGameScoreBoard()
        resetGameBoardOnNextRound()
        showGameWinState("\(currentPlayer) wins!", color: .green)
    }
    
    func showGameWinState(_ message: String, color: UIColor) {
        gameWinStateLabel.text = message
        gameWinStateLabel.textColor = color
        gameWinStateLabel.alpha = 1 // show label
        
        // fade out after 2 seconds
        UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseInOut, animations: {
            self.gameWinStateLabel.alpha = 0
        }, completion: nil)
    }
    
    func updateGameScoreBoard() {
        scorePlayer1Label.text = "\(scorePlayer1)" //shows current O or X score
        scorePlayer2Label.text = "\(scorePlayer2)"
    }
    
    func resetGameBoardOnNextRound() {
        gameBoardState = Array(repeating: " ", count: 9)
        gameResetManager.resetGameBoardOnNextRound(gameBoard: gameBoard)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        scorePlayer2 = 0
        scorePlayer1 = 0
        updateGameScoreBoard()
        gameResetManager.resetGameBoardOnResetButton(gameBoardState: &gameBoardState, gameBoard: gameBoard)
        gameStateLabel.text = "\(player1) starts"
    }
    
    
}

//different animations for reset button
class GameResetManager {
    
    func resetGameBoardOnResetButton(gameBoardState: inout [String], gameBoard: [UIButton]) {
        gameBoardState = Array(repeating: " ", count: 9)
        for button in gameBoard {
            button.setTitle(" ", for: .normal)
        }
    }
    
    func resetGameBoardOnNextRound(gameBoard: [UIButton]) {
            //disable user interaction for all buttons
            for button in gameBoard {
                button.isUserInteractionEnabled = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { //delay function 1s
                UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseInOut, animations: {
                    for button in gameBoard {
                        button.titleLabel?.alpha = 0
                    }
                }, completion: { _ in
                    for button in gameBoard {
                        button.setTitle(" ", for: .normal)
                        button.titleLabel?.alpha = 1
                        button.isUserInteractionEnabled = true //reset titles and enable user interaction for all buttons
                    }
                })
            }
        }
    }




