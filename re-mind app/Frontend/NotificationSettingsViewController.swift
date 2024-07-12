import UIKit
import UserNotifications

class NotificationSettingsViewController: UIViewController {
    @IBOutlet weak var frequencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var enableNotificationsSwitch: UISwitch!
    @IBOutlet weak var saveImageView: UIImageView!
    
    let frequencies = ["Hourly", "Daily", "Random"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tap gesture for the save button image view
        let saveTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped(_:)))
        saveImageView.addGestureRecognizer(saveTapGestureRecognizer)
        
        // Add target-actions for setting changes
        frequencySegmentedControl.addTarget(self, action: #selector(settingsChanged), for: .valueChanged)
        enableNotificationsSwitch.addTarget(self, action: #selector(remindersSwitchChanged), for: .valueChanged)
        
        // Load saved settings
        loadNotificationSettings()
        
        // Check notification authorization status
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                // print("Notifications are authorized")
            } else {
                print("Notifications are not authorized")
                DispatchQueue.main.async {
                    self.enableNotificationsSwitch.isEnabled = false
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load saved settings whenever the view appears
        loadNotificationSettings()
    }
    
    @objc func settingsChanged() {
        if enableNotificationsSwitch.isOn {
            saveImageView.image = UIImage(named: "unsaved") // Change to unsaved state
            saveImageView.isUserInteractionEnabled = true // Enable the save button
        }
    }
    
    @objc func remindersSwitchChanged() {
        let isSwitchOn = enableNotificationsSwitch.isOn
        saveImageView.image = isSwitchOn ? UIImage(named: "unsaved") : UIImage(named: "saved")
        saveImageView.isUserInteractionEnabled = isSwitchOn
        frequencySegmentedControl.isEnabled = isSwitchOn // Enable or disable the segmented control
        
        // Save the state of the switch immediately
        UserDefaults.standard.set(isSwitchOn, forKey: "remindersSwitchState")
        
        if !isSwitchOn {
            // If reminders are deactivated, clear all pending notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("Notifications have been de-activated")
        }
        
        if isSwitchOn {
            // If reminders are deactivated, clear all pending notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            saveNotificationSettings()
            saveImageView.image = UIImage(named: "saved") // Change to saved state
            saveImageView.isUserInteractionEnabled = false // Disable the save button
            print("Notifications are activated")
        }
    }
    
    @objc func saveButtonTapped(_ sender: UITapGestureRecognizer) {
        let selectedInterval = getInterval(for: frequencySegmentedControl.selectedSegmentIndex)
        UserDefaults.standard.set(selectedInterval, forKey: "notificationInterval")
        
        saveNotificationSettings()
        
        saveImageView.image = UIImage(named: "saved") // Change to saved state
        saveImageView.isUserInteractionEnabled = false // Disable the save button
    }
    
    private func saveNotificationSettings() {
        let isEnabled = enableNotificationsSwitch.isOn
        let frequencyIndex = frequencySegmentedControl.selectedSegmentIndex
        let frequency = frequencies[frequencyIndex]
        
        // Save these settings (for simplicity, saving to UserDefaults)
        let settings = [
            "isEnabled": isEnabled,
            "frequency": frequency
        ] as [String : Any]
        
        UserDefaults.standard.set(settings, forKey: "notificationSettings")
        print("Notification settings saved: \(settings)")
        
        // Schedule notification if enabled
        if isEnabled {
            let interval = getInterval(for: frequencyIndex)
            NotificationScheduler().scheduleNotifications(interval: interval)
        }
    }
    
    private func loadNotificationSettings() {
        if let savedSettings = UserDefaults.standard.dictionary(forKey: "notificationSettings") {
            if let isEnabled = savedSettings["isEnabled"] as? Bool {
                enableNotificationsSwitch.isOn = isEnabled
            }
            if let frequency = savedSettings["frequency"] as? String, let index = frequencies.firstIndex(of: frequency) {
                frequencySegmentedControl.selectedSegmentIndex = index
            } else {
                frequencySegmentedControl.selectedSegmentIndex = 0 // Default to Hourly
            }
            saveImageView.image = UIImage(named: "saved")
            saveImageView.isUserInteractionEnabled = false // Disable the save button initially
            frequencySegmentedControl.isEnabled = enableNotificationsSwitch.isOn // Update segmented control based on switch state
            // print("Loaded notification settings: \(savedSettings)")
        } else {
            // Set everything to default activated state for first load
            enableNotificationsSwitch.isOn = true
            frequencySegmentedControl.isEnabled = true
            saveImageView.isUserInteractionEnabled = false // Initially, no need to save since this is the default
            frequencySegmentedControl.selectedSegmentIndex = 0 // Default to Hourly
            print("No saved notification settings found, setting defaults")
        }
        
        // Load the state of the switch
        if let switchState = UserDefaults.standard.value(forKey: "remindersSwitchState") as? Bool {
            enableNotificationsSwitch.isOn = switchState
            frequencySegmentedControl.isEnabled = switchState
            saveImageView.isUserInteractionEnabled = switchState
            saveImageView.image = switchState ? UIImage(named: "saved") : UIImage(named: "saved")
        }
    }
    
    private func getInterval(for index: Int) -> TimeInterval {
        switch index {
        case 0:
            return 60 * 60 // Hourly in seconds
        case 1:
            return 86400 // Daily in seconds
        case 2:
            return TimeInterval.random(in: 3600...86400) // Random between 1 hour and 24 hours
        default:
            return 60 * 60 // Default to Hourly
        }
    }
}
