import UserNotifications

class NotificationScheduler {
    func scheduleNotifications(interval: TimeInterval, startDate: Date) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let firstTrigger = UNTimeIntervalNotificationTrigger(timeInterval: max(startDate.timeIntervalSinceNow, 1), repeats: false)
        
        // Schedule the first notification at the start date
        scheduleNotification(trigger: firstTrigger, center: center)
        
        // Schedule subsequent notifications at the specified interval
        let repeatingTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        scheduleNotification(trigger: repeatingTrigger, center: center)
    }
    
    private func scheduleNotification(trigger: UNNotificationTrigger, center: UNUserNotificationCenter) {
        let content = UNMutableNotificationContent()
        content.title = "Re-Mind by Horizun"
        content.body = QuotesManager.shared.getRandomQuote() ?? "Stay motivated!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled with trigger: \(trigger)")
            }
        }
    }
}
