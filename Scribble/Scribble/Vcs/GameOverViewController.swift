import UIKit
import AudioToolbox

class GameOverViewController: UIViewController {
    
    @IBOutlet var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "Score: \(ScriblleGameManager.shared.score)"
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        AudioServicesPlaySystemSound(1152)
        ScriblleGameManager.shared.inGame = false
        ScriblleGameManager.shared.resetGame()
        self.navigationController?.popToRootViewController(animated: true)
        
    }
}
