import Foundation

class QuotesManager {
    static let shared = QuotesManager()
    private var quotesDict: [String: [Quote]] = [:]
    private var selectedQuotesPool: [Quote] = []

    private init() {}

    func loadQuotes(completion: @escaping () -> Void) {
        GoogleSheetsService().fetchQuotes { [weak self] fetchedQuotes in
            guard let self = self, let fetchedQuotes = fetchedQuotes else {
                completion()
                return
            }

            for quote in fetchedQuotes {
                self.quotesDict[quote.interest, default: []].append(quote)
            }

            // Preload selected quotes
            self.preloadSelectedQuotes()

            completion()
        }
    }

    func addQuotes(for interest: String) {
        selectedQuotesPool += quotesDict[interest] ?? []
        printSelectedQuotesPool()
    }

    func getRandomQuote() -> Quote? {
            guard !selectedQuotesPool.isEmpty else { return nil }
            return selectedQuotesPool.randomElement()
        }

    func resetSelectedQuotesPool() {
        selectedQuotesPool.removeAll()
        print("Selected quotes pool reset")
    }

    func preloadSelectedQuotes() {
        if let savedSelections = UserDefaults.standard.object(forKey: "selectedInterests") as? [String] {
            for interest in savedSelections {
                addQuotes(for: interest)
            }
        }
    }

    func printSelectedQuotesPool() {
        // print("Current selected quotes pool: \(selectedQuotesPool.map { $0.quote })")
    }
}
