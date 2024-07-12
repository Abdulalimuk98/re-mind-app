import UIKit

class LatestReminderViewController: UIViewController {
    @IBOutlet weak var reminderCategoryImageView: UIImageView!
    @IBOutlet weak var latestReminderLabel: UILabel!
    @IBOutlet weak var reminderAuthorLabel: UILabel!
    @IBOutlet weak var shuffleButtonImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up long press gesture recognizer for the shuffle button
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(shuffleButtonLongPressed(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0 // Make it respond immediately
        shuffleButtonImageView.isUserInteractionEnabled = true
        shuffleButtonImageView.addGestureRecognizer(longPressGestureRecognizer)
        
        // Set the initial image for the shuffle button
        shuffleButtonImageView.image = UIImage(named: "shuffle default")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload the quotes pool and update the UI whenever the view appears
        reloadQuotes()
        loadLatestReminderData()
    }

    // Method to reload the quotes pool and update the UI
    func reloadQuotes() {
        QuotesManager.shared.resetSelectedQuotesPool()
        if let selectedInterests = UserDefaults.standard.object(forKey: "selectedInterests") as? [String] {
            for interest in selectedInterests {
                QuotesManager.shared.addQuotes(for: interest)
            }
        }
    }

    // Method to update the UI with the latest reminder
    func loadLatestReminderData() {
        // Retrieve the latest quote from UserDefaults
        if let latestQuoteData = UserDefaults.standard.data(forKey: "latestQuote"),
           let latestQuote = try? JSONDecoder().decode(Quote.self, from: latestQuoteData) {
            updateUI(with: latestQuote)
        } else {
            // If no quote is found in UserDefaults, get a new random quote
            if let newQuote = QuotesManager.shared.getRandomQuote() {
                saveQuoteToUserDefaults(newQuote)
                updateUI(with: newQuote)
            }
        }
    }

    @objc func shuffleButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            // Change the shuffle button image to pressed state
            shuffleButtonImageView.image = UIImage(named: "shuffle pressed")
        } else if sender.state == .ended || sender.state == .cancelled {
            // Get a new random quote
            if let newQuote = QuotesManager.shared.getRandomQuote() {
                // Save the new quote as the latest quote
                saveQuoteToUserDefaults(newQuote)
                // Update the UI with the new quote
                updateUI(with: newQuote)
            }
            
            // Revert the image back to default state
            shuffleButtonImageView.image = UIImage(named: "shuffle default")
        }
    }

    // Method to update the UI with a given quote
    private func updateUI(with quote: Quote) {
        let components = quote.quote.components(separatedBy: " - ")
        latestReminderLabel.text = components.first
        reminderAuthorLabel.text = components.count > 1 ? components.last : "" // If there's no author, leave it blank
        reminderCategoryImageView.image = UIImage(named: "\(quote.interest.lowercased()) default")
    }

    // Method to save a quote to UserDefaults
    private func saveQuoteToUserDefaults(_ quote: Quote) {
        if let quoteData = try? JSONEncoder().encode(quote) {
            UserDefaults.standard.set(quoteData, forKey: "latestQuote")
        }
    }
}
