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

        QuotesManager.shared.loadQuotes {
            DispatchQueue.main.async {
                self.setupImageViews()
                self.loadSavedSelections()
            }
        }

        // Set up tap gesture for the save button image view
        let saveTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped(_:)))
        saveImageView.isUserInteractionEnabled = true
        saveImageView.addGestureRecognizer(saveTapGestureRecognizer)
    }

    func setupImageViews() {
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
    }

    func loadSavedSelections() {
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
    }

    func saveSelectedInterests() {
        let selectedInterestsArray = Array(selectedInterests)
        UserDefaults.standard.set(selectedInterestsArray, forKey: "selectedInterests")
        print("Saved selected interests: \(selectedInterestsArray)")
        
        QuotesManager.shared.resetSelectedQuotesPool()
        for interest in selectedInterests {
            QuotesManager.shared.addQuotes(for: interest)
        }
    }
}
