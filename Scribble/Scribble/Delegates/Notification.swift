
import UIKit

extension Notification.Name {
    static let authenticationStateChanged = Notification.Name("AuthenticationStateChangedNotification")
    
    static let gameStateChangedNotification = Notification.Name("GameStateChangedNotification")
    
    static let isTimeKeeperChangedNotification = Notification.Name("IsTimeKeeperChangedNotification")
    
    static let currentlyDrawingChangedNotification = Notification.Name("CurrentlyDrawingChangedNotification")
    
    static let drawPromptChangedNotification = Notification.Name("DrawPromptChangedNotification")
    
    static let pastGuessesChangedNotification = Notification.Name("PastGuessesChangedNotification")
    
    static let scoreChangedNotification = Notification.Name("ScoreChangedNotification")
    
    static let remainingTimeChangedNotification = Notification.Name("RemainingTimeChangedNotification")
    
    static let lastReceivedDrawingChangedNotification = Notification.Name("LastReceivedDrawingChangedNotification")
}
