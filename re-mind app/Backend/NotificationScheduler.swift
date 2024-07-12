import UserNotifications

class NotificationScheduler {
    private var interval: TimeInterval = 0
    
    func scheduleNotifications(interval: TimeInterval) {
        self.interval = interval
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let startTime = Date()

        // Schedule the first notification 5 seconds after pressing save
        let firstTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        scheduleNotification(trigger: firstTrigger, center: center)
        
        // Schedule subsequent notifications
        let count = 63 // Adjust the count as needed
        scheduleSubsequentNotifications(center: center, count: count)
        
        let endTime = Date()
        let timeInterval = endTime.timeIntervalSince(startTime)
        print("\(count) notifications successfully scheduled in \(timeInterval) seconds")
    }
    
    private func scheduleNotification(trigger: UNNotificationTrigger, center: UNUserNotificationCenter) {
        let content = createNotificationContent()
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                // print("Notification scheduled with trigger: \(trigger)")
            }
        }
    }

    private func scheduleSubsequentNotifications(center: UNUserNotificationCenter, count: Int) {
        for i in 1...count {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i) * interval, repeats: false)
            scheduleNotification(trigger: trigger, center: center)
        }
    }

    private func createNotificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "re-mind"
        if let randomQuote = QuotesManager.shared.getRandomQuote() {
            content.body = randomQuote.quote
            // print("Scheduling notification with quote: \(randomQuote.quote)")
        } else {
            content.body = "You are capable of more than you think."
            print("Scheduling notification with default quote: Stay motivated!")
        }
        content.sound = .default
        return content
    }
}

extension UNNotificationTrigger {
    func nextTriggerDate() -> Date? {
        if let intervalTrigger = self as? UNTimeIntervalNotificationTrigger {
            return Date().addingTimeInterval(intervalTrigger.timeInterval)
        }
        return nil
    }
}
