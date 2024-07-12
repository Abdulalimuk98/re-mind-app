import Foundation
import UserNotifications

class NotificationSchedulerOperation: Operation {
    override func main() {
        if isCancelled {
            return
        }

        let center = UNUserNotificationCenter.current()
        let interval = UserDefaults.standard.double(forKey: "notificationInterval")
        let content = UNMutableNotificationContent()
        content.title = "re-mind"
        if let randomQuote = QuotesManager.shared.getRandomQuote() {
            content.body = randomQuote.quote
            print("Scheduling notification with quote: \(randomQuote.quote)")
        } else {
            content.body = "Stay motivated!"
            print("Scheduling notification with default quote: Stay motivated!")
        }
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false))
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled")
            }
        }
    }
}
