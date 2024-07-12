import UIKit

class OnboardingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pageViewController: UIPageViewController!
    
    let pages = [
        "OnboardingPage1ViewController",
        "OnboardingPage2ViewController",
        "OnboardingPage3ViewController",
        "OnboardingPage4ViewController",
        "OnboardingPage5ViewController"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
    }

    func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        if let firstViewController = viewControllerAtIndex(0) {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        // Set constraints for the pageViewController's view to fill the screen
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80)
        ])
    }

    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if index < 0 || index >= pages.count {
            return nil
        }
        return storyboard?.instantiateViewController(withIdentifier: pages[index])
    }

    // MARK: - UIPageViewController DataSource Methods

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let identifier = viewController.restorationIdentifier, let index = pages.firstIndex(of: identifier) else {
            return nil
        }
        let previousIndex = index - 1
        return viewControllerAtIndex(previousIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let identifier = viewController.restorationIdentifier, let index = pages.firstIndex(of: identifier) else {
            return nil
        }
        let nextIndex = index + 1
        return viewControllerAtIndex(nextIndex)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    // MARK: - UIPageViewController Delegate Methods

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers.first,
           let index = pages.firstIndex(of: viewController.restorationIdentifier ?? "") {
            updatePageControls(for: index)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: viewController.restorationIdentifier ?? "") {
            updatePageControls(for: index)
        }
    }

    func updatePageControls(for index: Int) {
        if let viewController = viewControllerAtIndex(index) as? OnboardingPage1ViewController {
            viewController.updatePageControl(currentPage: index, numberOfPages: pages.count)
        } else if let viewController = viewControllerAtIndex(index) as? OnboardingPage2ViewController {
            viewController.updatePageControl(currentPage: index, numberOfPages: pages.count)
        } else if let viewController = viewControllerAtIndex(index) as? OnboardingPage3ViewController {
            viewController.updatePageControl(currentPage: index, numberOfPages: pages.count)
        } else if let viewController = viewControllerAtIndex(index) as? OnboardingPage4ViewController {
            viewController.updatePageControl(currentPage: index, numberOfPages: pages.count)
        } else if let viewController = viewControllerAtIndex(index) as? OnboardingPage5ViewController {
            viewController.updatePageControl(currentPage: index, numberOfPages: pages.count)
        }
    }
}
