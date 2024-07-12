import UIKit

class InformationViewController: UIViewController {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var privacyPolicyImageView: UIImageView!
    @IBOutlet weak var termsOfServiceImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the app version
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version \(version)"
        }
        
        // Set up image views
        let contactTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contactTapped))
        contactImageView.isUserInteractionEnabled = true
        contactImageView.addGestureRecognizer(contactTapGestureRecognizer)
        
        let rateTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rateTapped))
        rateImageView.isUserInteractionEnabled = true
        rateImageView.addGestureRecognizer(rateTapGestureRecognizer)
        
        let privacyPolicyTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTapped))
        privacyPolicyImageView.isUserInteractionEnabled = true
        privacyPolicyImageView.addGestureRecognizer(privacyPolicyTapGestureRecognizer)
        
        let termsOfServiceTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(termsOfServiceTapped))
        termsOfServiceImageView.isUserInteractionEnabled = true
        termsOfServiceImageView.addGestureRecognizer(termsOfServiceTapGestureRecognizer)
    }
    
    @objc func contactTapped() {
        if let url = URL(string: "mailto:abdul@horizun.co.uk") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func rateTapped() {
        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func privacyPolicyTapped() {
        if let url = URL(string: "https://re-mind.framer.ai/privacy-policy") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func termsOfServiceTapped() {
        if let url = URL(string: "https://re-mind.framer.ai/terms-of-service") {
            UIApplication.shared.open(url)
        }
    }
}
