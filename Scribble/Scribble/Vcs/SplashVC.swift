import UIKit
import Lottie

class SplashVC: UIViewController {
    
    @IBOutlet var ReceipeAnimation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let lottieView = LottieAnimationView(name: "Animation")
        lottieView.loopMode = .loop
        lottieView.contentMode = .scaleAspectFit

        ReceipeAnimation.addSubview(lottieView)
        
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lottieView.topAnchor.constraint(equalTo: ReceipeAnimation.topAnchor),
            lottieView.leadingAnchor.constraint(equalTo: ReceipeAnimation.leadingAnchor),
            lottieView.trailingAnchor.constraint(equalTo: ReceipeAnimation.trailingAnchor),
            lottieView.bottomAnchor.constraint(equalTo: ReceipeAnimation.bottomAnchor)
        ])

        lottieView.play()

        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5, execute: {
             
            self.dismiss(animated: true)
            
            
        })
        
    }


}
