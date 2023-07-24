//
//  SettingsVC.swift
//  TTT
//
//  Created by Asher Chok on 7/8/23.
//

import UIKit

protocol SettingsVCDelegate: AnyObject {
    func didSelectPlayerOption(player1: String, player2: String)
    func didUpdatePlayerSymbols(player1: String, player2: String)
    func didUpdateAnimationStatus(_ status: Bool)
}


class SettingsVC: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedBGControl: UISegmentedControl!
    @IBOutlet weak var selectionLabel: UILabel!
    
    weak var delegate: SettingsVCDelegate?
    var updateCallback: ((String,String) -> Void)?
    var didselectCallback: ((String,String) -> Void)?
    
    var player1: String = "O" //default player1 and player2 str
    var player2: String = "X"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.removeAllSegments()
        for (index, option) in changePlayerOptions.enumerated() {
            segmentedControl.insertSegment(withTitle: option, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = setSegment()
        segmentedControlValueChanged(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        

    }
    
    //user setting options
    let changePlayerOptions = ["O & X", "🐶 & 🐱", "🤪 & 😎","🤓 & 😹"]
    let changeBGOptions = ["ON", "OFF"]

    func setSegment() -> Int {
        switch player1 {
        case "O": return 0
        case "🐶": return 1
        case"🤪": return 2
        case"🤓": return 3
        default: return 0
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedOption = changePlayerOptions[sender.selectedSegmentIndex]
        switch selectedOption {
        case "O & X (Default)":
            player1 = "O"
            player2 = "X"
        case "🐶 & 🐱":
            player1 = "🐶"
            player2 = "🐱"
        case "🤪 & 😎":
            player1 = "🤪"
            player2 = "😎"
        case "🤓 & 😹":
            player1 = "🤓"
            player2 = "😹"
        default:
            break
        }
        didselectCallback?(player1,player2)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        print("SettingsVC: Updating player symbols to \(player1) and \(player2)") //debug
        updateCallback?(player1,player2)
    }
    
    //issue with anim button
    @IBAction func animationSwitchValueChanged(_ sender: UISegmentedControl) {
        let animationEnabled = sender.selectedSegmentIndex == 0
            UserDefaults.standard.set(animationEnabled, forKey: "BackgroundAnimation")
            delegate?.didUpdateAnimationStatus(animationEnabled)
        }
    
    

}


