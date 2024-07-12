import UIKit

class InterestsViewController: UIViewController {
    @IBOutlet weak var fitnessImageView: UIImageView!
    @IBOutlet weak var productivityImageView: UIImageView!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var stoicismImageView: UIImageView!
    @IBOutlet weak var spiritualityImageView: UIImageView!
    @IBOutlet weak var wellbeingImageView: UIImageView!
    @IBOutlet weak var scienceImageView: UIImageView!
    @IBOutlet weak var disciplineImageView: UIImageView!
    @IBOutlet weak var moneyImageView: UIImageView!
    @IBOutlet weak var saveImageView: UIImageView!

    var selectedInterests: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageViews = [
            "Fitness": fitnessImageView,
            "Productivity": productivityImageView,
            "Business": businessImageView,
            "Stoicism": stoicismImageView,
            "Spirituality": spiritualityImageView,
            "Wellbeing": wellbeingImageView,
            "Science": scienceImageView,
            "Discipline": disciplineImageView,
            "Money": moneyImageView
        ]

        for (interest, imageView) in imageViews {
            imageView?.image = UIImage(named: "\(interest.lowercased()) default") // Set default image
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView?.isUserInteractionEnabled = true
            imageView?.addGestureRecognizer(tapGestureRecognizer)
            imageView?.tag = interest.hashValue // Use hash value as a unique identifier
        }

        // Load saved selections
        if let savedSelections = UserDefaults.standard.object(forKey: "selectedInterests") as? [String] {
            selectedInterests = Set(savedSelections)
            for interest in selectedInterests {
                if let imageView = imageViews[interest] {
                    imageView?.image = UIImage(named: "\(interest.lowercased()) selected")
                }
            }
            // Set save button to saved state if there are saved selections
            saveImageView.image = UIImage(named: "saved")
        } else {
            // Set save button to unsaved state if there are no saved selections
            saveImageView.image = UIImage(named: "unsaved")
        }

        // Set up tap gesture for the save button image view
        let saveTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped(_:)))
        saveImageView.isUserInteractionEnabled = true
        saveImageView.addGestureRecognizer(saveTapGestureRecognizer)
    }

    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        let interest = interestForImageView(tappedImageView)

        if selectedInterests.contains(interest) {
            // Deselect
            selectedInterests.remove(interest)
            tappedImageView.image = UIImage(named: "\(interest.lowercased()) default")
        } else {
            // Select
            selectedInterests.insert(interest)
            tappedImageView.image = UIImage(named: "\(interest.lowercased()) selected")
        }

        // Reset the save button to unsaved state
        saveImageView.image = UIImage(named: "unsaved")
    }

    func interestForImageView(_ imageView: UIImageView) -> String {
        switch imageView.tag {
        case "Fitness".hashValue:
            return "Fitness"
        case "Productivity".hashValue:
            return "Productivity"
        case "Business".hashValue:
            return "Business"
        case "Stoicism".hashValue:
            return "Stoicism"
        case "Spirituality".hashValue:
            return "Spirituality"
        case "Wellbeing".hashValue:
            return "Wellbeing"
        case "Science".hashValue:
            return "Science"
        case "Discipline".hashValue:
            return "Discipline"
        case "Money".hashValue:
            return "Money"
        default:
            return ""
        }
    }

    @objc func saveButtonTapped(_ sender: UITapGestureRecognizer) {
        saveSelectedInterests()
        saveImageView.image = UIImage(named: "saved") // Change to saved state
        
        // Enable reminders and schedule notifications
        UserDefaults.standard.set(true, forKey: "remindersSwitchState")
        UserDefaults.standard.set("5 minutes", forKey: "frequency") // Set default frequency to 5 minutes
        let interval = getInterval(for: "5 minutes")
        NotificationScheduler().scheduleNotifications(interval: interval)
    }

    func saveSelectedInterests() {
        let selectedInterestsArray = Array(selectedInterests)
        UserDefaults.standard.set(selectedInterestsArray, forKey: "selectedInterests")
        print("Saved selected interests: \(selectedInterestsArray)")
        
        // Reload quotes pool based on selected interests
        QuotesManager.shared.resetSelectedQuotesPool()
        for interest in selectedInterests {
            QuotesManager.shared.addQuotes(for: interest)
        }
    }

    private func getInterval(for frequency: String) -> TimeInterval {
        switch frequency {
        case "5 minutes":
            return 60 // 5 minutes in seconds (temporarily 60 seconds for testing)
        case "15 minutes":
            return 900 // 15 minutes in seconds
        case "30 minutes":
            return 1800 // 30 minutes in seconds
        case "Hourly":
            return 3600 // 1 hour in seconds
        default:
            return 60 // Default to 5 minutes
        }
    }
}
