import UIKit
import SwiftUI
import Combine
import AudioToolbox

class MenuViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var matchManager = ScriblleGameManager.shared
    private var authenticationStateObserver: AnyCancellable?
    private var isGameOverObserver: AnyCancellable?
    private var inGameObserver: AnyCancellable?
    private var isNavigatingToGameOver = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        matchManager.authenticateUser()
        setupViews()
        observeAuthenticationState()
        observeIsGameOver()
        observeInGame()
        self.performSegue(withIdentifier: "Splash", sender: self)
        
        updateUIForIsGameOver()
        updateUIForInGame()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        matchManager = ScriblleGameManager.shared
        updateUIForAuthenticationState()
    }
 
    
    func setupViews() {
        // Configure play button
        playButton.layer.cornerRadius = 20
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        // Update status label
        statusLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
  
    
    private func observeAuthenticationState() {
        authenticationStateObserver = matchManager.$authenticationState.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateUIForAuthenticationState()
            }
        }
    }

    private func observeIsGameOver() {
        isGameOverObserver = matchManager.$isGameOver.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateUIForIsGameOver()
            }
        }
    }

    private func observeInGame() {
        inGameObserver = matchManager.$inGame.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateUIForInGame()
            }
        }
    }

    @objc func authenticationStateChanged() {
        // Handle authentication state change
        updateUIForAuthenticationState()
    }

    func updateUIForAuthenticationState() {
        // Update UI based on authentication state
        let authState = matchManager.authenticationState
        switch authState {
        case .authenticating:
            statusLabel.text = PlayerAuthState.authenticating.rawValue
            playButton.isEnabled = false
            playButton.backgroundColor = .gray
        case .unauthenticated:
            statusLabel.text = PlayerAuthState.unauthenticated.rawValue
            playButton.isEnabled = false
            playButton.backgroundColor = .gray
        case .authenticated:
            statusLabel.text = PlayerAuthState.authenticated.rawValue
            playButton.isEnabled = !matchManager.inGame
            playButton.backgroundColor = matchManager.inGame ? .gray : UIColor(named: "playBtn")
        case .error:
            statusLabel.text = PlayerAuthState.error.rawValue
            playButton.isEnabled = false
            playButton.backgroundColor = .gray
        case .restricted:
            statusLabel.text = PlayerAuthState.restricted.rawValue
            playButton.isEnabled = false
            playButton.backgroundColor = .gray
        }
    }
    
    func updateUIForIsGameOver() {
            // Update UI based on isGameOver state
            if matchManager.isGameOver == true && !isNavigatingToGameOver {
                isNavigatingToGameOver = true
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameOverViewController") as! GameOverViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    
    func updateUIForInGame() {
        // Update UI based on inGame state
        if matchManager.inGame {
            
            DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                 
                let game = GameView(matchManager: ScriblleGameManager.shared)
                let hostingController = UIHostingController(rootView: game)
                hostingController.hidesBottomBarWhenPushed = true
                self.navigationController!.pushViewController(hostingController, animated: true)
                
            })
            
            
        } else {
            
            print("Handle  not in game state")
        }
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        
        
        AudioServicesPlaySystemSound(1152)
        
        
        matchManager.startMatchmaking()
        
    }

    deinit {
        // Remove observers when deinitialized
        authenticationStateObserver?.cancel()
        isGameOverObserver?.cancel()
        inGameObserver?.cancel()
        NotificationCenter.default.removeObserver(self)
    }
}
