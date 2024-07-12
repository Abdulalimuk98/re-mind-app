import UIKit

class OnboardingPage5ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var proceedButtonImageView: UIImageView!

    let googleScriptURL = "https://script.google.com/macros/s/AKfycbz_megg5hPKuPtdl492IJCREr3y6Wkd2kLO_Z_14Ycg8u_jmyErsZrEvk0z50lYL1R-/exec"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmailTextField()
        setupProceedButton()
        emailTextField.delegate = self
    }

    func setupEmailTextField() {
        emailTextField.layer.cornerRadius = 20
        emailTextField.layer.borderWidth = 0.5
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add padding to the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 43))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = .always

        NSLayoutConstraint.activate([
            emailTextField.widthAnchor.constraint(equalToConstant: 350),
            emailTextField.heightAnchor.constraint(equalToConstant: 43),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 369)
        ])
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    func setupProceedButton() {
        proceedButtonImageView.image = UIImage(named: "let's go default")
        proceedButtonImageView.isUserInteractionEnabled = true

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(proceedButtonLongPressed(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0

        proceedButtonImageView.addGestureRecognizer(longPressGestureRecognizer)
    }

    func updatePageControl(currentPage: Int, numberOfPages: Int) {
        pageControl?.currentPage = currentPage
        pageControl?.numberOfPages = numberOfPages
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let email = textField.text, isValidEmail(email) {
            proceedButtonImageView.image = UIImage(named: "let's go ready")
        } else {
            proceedButtonImageView.image = UIImage(named: "let's go default")
        }
    }

    @objc func proceedButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            proceedButtonImageView.image = UIImage(named: "let's go default")
        } else if sender.state == .ended || sender.state == .cancelled {
            guard let email = emailTextField.text, isValidEmail(email) else {
                print("Invalid email")
                return
            }

            proceedButtonImageView.image = UIImage(named: "let's go default")
            print("Valid email: \(email)")

            // Save email to Google Sheets
            saveEmailToGoogleSheets(email: email) { success in
                if success {
                    print("Email saved to Google Sheets")
                    // Mark onboarding as completed
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    // Navigate to the main view controller
                    DispatchQueue.main.async {
                        self.navigateToMainViewController()
                    }
                } else {
                    print("Failed to save email to Google Sheets")
                    // Show an error message
                    DispatchQueue.main.async {
                        // Show error message to user
                    }
                }
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        // Simple email validation logic
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func saveEmailToGoogleSheets(email: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: googleScriptURL) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "email=\(email)"
        request.httpBody = postString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: \(error!)")
                completion(false)
                return
            }
            completion(true)
        }
        task.resume()
    }

    func navigateToMainViewController() {
        if let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") {
            mainViewController.modalPresentationStyle = .fullScreen
            present(mainViewController, animated: true, completion: nil)
        }
    }
}
