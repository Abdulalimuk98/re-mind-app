import UIKit

class OnboardingPage4ViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup if needed
    }
    
    func updatePageControl(currentPage: Int, numberOfPages: Int) {
        pageControl?.currentPage = currentPage
        pageControl?.numberOfPages = numberOfPages
    }
}
