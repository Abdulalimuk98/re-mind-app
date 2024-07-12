import UserNotifications

class NotificationScheduler {
    func scheduleNotifications(interval: TimeInterval) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        // Schedule the first notification 5 seconds after pressing save
        let firstTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        scheduleNotification(trigger: firstTrigger, center: center)
        
        // Schedule subsequent notifications at the specified interval
        let repeatingTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        scheduleRepeatingNotifications(trigger: repeatingTrigger, center: center, interval: interval)
    }
    
    private func scheduleNotification(trigger: UNNotificationTrigger, center: UNUserNotificationCenter) {
        let content = createNotificationContent()
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled with trigger: \(trigger)")
            }
        }
    }
    
    private func scheduleRepeatingNotifications(trigger: UNTimeIntervalNotificationTrigger, center: UNUserNotificationCenter, interval: TimeInterval) {
        for i in 1...2 { // Only print the first two notifications for debugging
            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval * Double(i), repeats: false)
            scheduleNotification(trigger: newTrigger, center: center)
        }
    }
    
    private func createNotificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Re-Mind"
        if let randomQuote = QuotesManager.shared.getRandomQuote() {
            content.body = randomQuote.quote
            print("Scheduling notification with quote: \(randomQuote.quote)")
        } else {
            content.body = "Stay motivated!"
            print("Scheduling notification with default quote: Stay motivated!")
        }
        content.sound = .default
        return content
    }
}
