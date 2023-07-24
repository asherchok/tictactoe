//
//  MainVC.swift
//  TTT
//
//  Created by Asher Chok on 6/24/23.
//

import UIKit

class MainVC: UIViewController, SettingsVCDelegate {
    func didUpdateAnimationStatus(_ status: Bool) {
        //
    }
    
    var player1: String = "O"
    var player2: String = "X"
    
    // for the background animation class
    var animationLayers: [CALayer] = []
    var mainMenuBackground: MainMenuBackground?
    
    func didSelectPlayerOption(player1: String, player2: String) {
       self.player1 = player1
        self.player2 = player2
        updatePlayerOption(player1: player1, player2: player2)
    }
    
    func didUpdatePlayerSymbols(player1: String, player2: String) {
        print("MainVC: Received player symbols update to \(player1) and \(player2)") //debug1
       self.player1 = player1
        self.player2 = player2
        mainMenuBackground?.updateBackgroundAnimation(view: view)
        if let tttVC = self.presentedViewController as? TTTVC {
            tttVC.didUpdatePlayerSymbols(player1: player1, player2: player2)
        }
    }
    
    func updatePlayerOption(player1: String, player2: String) {
        if let tttVC = self.presentedViewController as? TTTVC {
            tttVC.didSelectPlayerOption(player1: player1, player2: player2)
        }
    }
    
    func getPlayerSymbol(from option: String, index: Int) -> String {
        let components = option.components(separatedBy: " & ")
        guard components.count == 2 else {
            return ""
        }
        return components[index]
    }
    
 
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if UserDefaults.standard.object(forKey: "BackgroundAnimation") == nil {
            UserDefaults.standard.set(true, forKey: "BackgroundAnimation")
        }
        print("BackgroundAnimation value:", UserDefaults.standard.bool(forKey: "BackgroundAnimation")) // Debug print

        return true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tttVC = segue.destination as? TTTVC {
            tttVC.didUpdatePlayerSymbols(player1: player1, player2: player2)
        }
    }

    @IBAction func beginButtonTapped(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TTTVC") as? TTTVC {
            vc.player1 = player1
            vc.player2 = player2
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        if let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVCID") as? SettingsVC {
            settingsVC.player1 = player1
            settingsVC.player2 = player2
            settingsVC.didselectCallback = { player1, player2 in
                self.player1 = player1
                self.player2 = player2
            }
            settingsVC.updateCallback = { player1, player2 in
                self.player1 = player1
                self.player2 = player2
            }
            self.navigationController?.present(settingsVC, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad MainVC called")
        mainMenuBackground = MainMenuBackground(player1: player1, player2: player2, view: view)
        print("updateBackgroundAnimation called before viewDidAppear") // Debug print
        mainMenuBackground?.updateBackgroundAnimation(view: view)
        updateBackgroundAnimation()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBackgroundAnimation()
    }

    func updateBackgroundAnimation() {
        guard let mainMenuBackground = mainMenuBackground else {
            return // ensure mainMenuBackground is not nil
        }
        mainMenuBackground.updateBackgroundAnimation(view: view)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait // lock orientation to only show portrait
    }

}

// background animations in main menu
class MainMenuBackground {
    private var patternLayer: CALayer?
    private var player1: String
    private var player2: String
    
    init(player1: String, player2: String, view: UIView) {
        self.player1 = player1
        self.player2 = player2
        updateBackgroundAnimation(view: view)
    }
    
    func updateBackgroundAnimation(view: UIView) {
        // remove any previous pattern layer
        patternLayer?.removeFromSuperlayer()
        
        // add a new pattern layer only if UserDefaults allows it
        if UserDefaults.standard.bool(forKey: "BackgroundAnimation") {
            let image = createGridPattern()
            patternLayer = CALayer()
            patternLayer?.backgroundColor = UIColor(patternImage: image).cgColor
            patternLayer?.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 3, height: view.bounds.height * 3)
            
            // animation
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.byValue = Bool.random() ? view.bounds.width : -view.bounds.width
            animation.repeatCount = .infinity
            animation.duration = 8.0
            patternLayer?.add(animation, forKey: "patternAnimation")
            
            view.layer.insertSublayer(patternLayer!, at: 0)
        }
    }
    
    private func createGridPattern() -> UIImage {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        for i in 0..<6 {
            for j in 0..<6 {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
                label.text = (i + j) % 2 == 0 ? player2 : player1
                label.textAlignment = .center
                label.alpha = 0.1
                label.frame = CGRect(x: 50 * i, y: 50 * j, width: 50, height: 50)
                view.addSubview(label)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

