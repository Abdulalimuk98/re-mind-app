import Foundation

struct Quote: Decodable {
    let interest: String
    let quote: String
}

class GoogleSheetsService {
    private let apiKey = "AIzaSyDHaKswwlLv9ltZeYbuVQrKdIy8J1qCqAM"
    private let sheetId = "1spfRRY0kPV_tpDJTSQ9BKE777OdKSq92gX2nJ0YBNzA"
    private let range = "Sheet1!A:J"

    func fetchQuotes(completion: @escaping ([Quote]?) -> Void) {
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetId)/values/\(range)?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "No error description")")
                completion(nil)
                return
            }

            do {
                let quotes = try self.parseQuotes(from: data)
                completion(quotes)
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    private func parseQuotes(from data: Data) throws -> [Quote] {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let values = json?["values"] as? [[String]] else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
        }

        var quotes = [Quote]()
        let interests = values[0].dropFirst() // Skip the first column header

        for row in values.dropFirst() { // Skip the header row
            for (index, interest) in interests.enumerated() {
                if row.count > index + 1, !row[index + 1].isEmpty {
                    quotes.append(Quote(interest: String(interest), quote: row[index + 1]))
                }
            }
        }
        return quotes
    }
}
