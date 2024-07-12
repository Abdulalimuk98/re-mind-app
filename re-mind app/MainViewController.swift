import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var watermark: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QuotesManager.shared.loadQuotes {
        }

        // Set the initial selected segment to the index of the InterestsViewController
        segmentedControl.selectedSegmentIndex = 1
        
        // Add action for the segmented control
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        // Initialize and add the initial view controller
        updateView()
        
        // Set up tap gesture recognizer for watermark
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(watermarkTapped(_:)))
        watermark.isUserInteractionEnabled = true
        watermark.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
    @objc func watermarkTapped(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://re-mind.framer.ai") {
            UIApplication.shared.open(url)
        }
    }
    
    private func updateView() {
        // Remove current view controller
        if let currentVC = currentViewController {
            remove(asChildViewController: currentVC)
        }
        
        // Add new view controller based on the selected segment
        let storyboardID: String
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            storyboardID = "LatestReminderViewController"
        case 1:
            storyboardID = "InterestsViewController"
        case 2:
            storyboardID = "NotificationSettingsViewController"
        case 3:
            storyboardID = "InformationViewController"
        default:
            storyboardID = "LatestReminderViewController"
        }
        
        if let newViewController = storyboard?.instantiateViewController(withIdentifier: storyboardID) {
            currentViewController = newViewController
            add(asChildViewController: newViewController)
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
}

