import UIKit
import UserNotifications

class NotificationSettingsViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var frequencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var enableNotificationsSwitch: UISwitch!
    @IBOutlet weak var saveImageView: UIImageView!

    let frequencies = ["15 minutes", "30 minutes", "Hourly", "Daily"]
    let frequencyIntervals: [TimeInterval] = [900, 1800, 3600, 86400]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure initial state
        enableNotificationsSwitch.isOn = false

        // Set up tap gesture for the save button image view
        let saveTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped(_:)))
        saveImageView.isUserInteractionEnabled = true
        saveImageView.addGestureRecognizer(saveTapGestureRecognizer)
        saveImageView.image = UIImage(named: "unsaved") // Set initial image

        // Add target-actions for setting changes
        datePicker.addTarget(self, action: #selector(settingsChanged), for: .valueChanged)
        frequencySegmentedControl.addTarget(self, action: #selector(settingsChanged), for: .valueChanged)
        enableNotificationsSwitch.addTarget(self, action: #selector(settingsChanged), for: .valueChanged)

        // Load saved settings
        loadNotificationSettings()

        // Check notification authorization status
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                print("Notifications are authorized")
            } else {
                print("Notifications are not authorized")
                DispatchQueue.main.async {
                    self.enableNotificationsSwitch.isEnabled = false
                }
            }
        }
    }

    @objc func settingsChanged() {
        saveImageView.image = UIImage(named: "unsaved") // Change to unsaved state
    }

    @objc func saveButtonTapped(_ sender: UITapGestureRecognizer) {
        saveNotificationSettings()
        saveImageView.image = UIImage(named: "saved") // Change to saved state
    }

    private func saveNotificationSettings() {
        let isEnabled = enableNotificationsSwitch.isOn
        let frequencyIndex = frequencySegmentedControl.selectedSegmentIndex
        let frequency = frequencies[frequencyIndex]
        let interval = frequencyIntervals[frequencyIndex]
        let startDate = datePicker.date

        // Save these settings (for simplicity, saving to UserDefaults)
        let settings = [
            "isEnabled": isEnabled,
            "frequency": frequency,
            "startDate": startDate
        ] as [String : Any]

        UserDefaults.standard.set(settings, forKey: "notificationSettings")
        print("Notification settings saved: \(settings)")

        // Schedule notification if enabled
        if isEnabled {
            NotificationScheduler().scheduleNotifications(interval: interval, startDate: startDate)
        }
    }

    private func loadNotificationSettings() {
        if let savedSettings = UserDefaults.standard.dictionary(forKey: "notificationSettings") {
            if let isEnabled = savedSettings["isEnabled"] as? Bool {
                enableNotificationsSwitch.isOn = isEnabled
            }
            if let frequency = savedSettings["frequency"] as? String, let index = frequencies.firstIndex(of: frequency) {
                frequencySegmentedControl.selectedSegmentIndex = index
            }
            if let startDate = savedSettings["startDate"] as? Date {
                datePicker.date = startDate
            }
            // Set save button to saved state if there are saved settings
            saveImageView.image = UIImage(named: "saved")
            print("Loaded notification settings: \(savedSettings)")
        } else {
            // Set save button to unsaved state if there are no saved settings
            saveImageView.image = UIImage(named: "unsaved")
            print("No saved notification settings found")
        }
    }
}
