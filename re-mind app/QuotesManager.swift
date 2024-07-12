import Foundation

class QuotesManager {
    static let shared = QuotesManager()
    private var quotesDict: [String: [String]] = [:]
    private var selectedQuotesPool: [String] = []

    private init() {}

    func loadQuotes(completion: @escaping () -> Void) {
        GoogleSheetsService().fetchQuotes { [weak self] fetchedQuotes in
            guard let self = self, let fetchedQuotes = fetchedQuotes else {
                completion()
                return
            }

            for quote in fetchedQuotes {
                self.quotesDict[quote.interest, default: []].append(quote.quote)
            }
            completion()
        }
    }

    func addQuotes(for interest: String) {
        selectedQuotesPool += quotesDict[interest] ?? []
        print("Updated quotes pool after adding \(interest):")
        print(selectedQuotesPool)
    }

    func getRandomQuote() -> String? {
        return selectedQuotesPool.randomElement()
    }

    func resetSelectedQuotesPool() {
        selectedQuotesPool.removeAll()
        print("Quotes pool has been reset.")
    }
}
