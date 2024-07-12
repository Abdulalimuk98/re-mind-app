import Foundation
import FirebaseFirestore

class FirestoreService {
    func saveUserEmail(_ email: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").addDocument(data: [
            "email": email,
            "date": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
