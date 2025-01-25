//
//  FirebaseAuthHelper.swift
//  Group_06_Events
//
//  Created by Julia Prats on 2024-03-13.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

@MainActor
class FirebaseAuthHelper: ObservableObject{
    
    @Published var firebaseUser : FirebaseAuth.User?
    @Published var user: User?
    
    private let COLLECTION : String = "USERS"
    
    private let FIELD_ID : String = "id"
    private let FIELD_NAME : String = "name"
    private let FIELD_EMAIL : String = "email"
    private let FIELD_FAVOURITES : String = "favourites"
    private let FIELD_FRIENDS : String = "friends"
    
    init() {
        self.firebaseUser = Auth.auth().currentUser
        Task {
           await fetchUser()
        }
        
    }
    
    
    func addFriend(userToAdd: User) async throws {
        guard let currentUserID = firebaseUser?.uid else {
            throw AUTH_ERROR.CUSTOMER_ERROR
        }
        let currentUserRef = Firestore.firestore().collection(COLLECTION).document(currentUserID)
        
        // Add the user object to the current user's friends list
        try await currentUserRef.updateData([
            FIELD_FRIENDS: FieldValue.arrayUnion([try Firestore.Encoder().encode(userToAdd)])
        ])
    }
    
    func removeFriend(userToRemove: User) async throws {
        guard let currentUserID = firebaseUser?.uid else {
            throw AUTH_ERROR.CUSTOMER_ERROR
        }
        let currentUserRef = Firestore.firestore().collection(COLLECTION).document(currentUserID)
        
        // Remove the user object from the current user's friends list
        try await currentUserRef.updateData([
            FIELD_FRIENDS: FieldValue.arrayRemove([try Firestore.Encoder().encode(userToRemove)])
        ])
    }

    
    func searchUsers(query: String) async throws -> [User] {
        let querySnapshot = try await Firestore.firestore().collection(COLLECTION)
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments()
        
        let users = querySnapshot.documents.compactMap { document in
            try? Firestore.Decoder().decode(User.self, from: document.data())
        }
        
        return users
    }
    
    func listenForUserChanges(completion: @escaping (User) -> Void) -> ListenerRegistration {
        guard let uid = firebaseUser?.uid else {
            fatalError("No user logged in")
        }
        
        let listener = Firestore.firestore().collection(COLLECTION).document(uid).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists, let updatedUser = try? snapshot.data(as: User.self) else {
                return
            }
            completion(updatedUser)
        }
        
        return listener
    }

    func fetchFriends() async {
        do {
            guard let currentUser = user else {
                return
            }

            let friendsSnapshot = try await Firestore.firestore()
                .collection("USERS")
                .document(currentUser.id)
                .getDocument()

            guard let data = friendsSnapshot.data(),
                  let friendIds = data[FIELD_FRIENDS] as? [String] else {
                return
            }

            var fetchedFriends: [User] = []
            for friendId in friendIds {
                guard let friendSnapshot = try? await Firestore.firestore()
                    .collection("USERS")
                    .document(friendId)
                    .getDocument(),
                    let friend = try? friendSnapshot.data(as: User.self) else {
                        continue
                }
                fetchedFriends.append(friend)
            }

            user?.friends = fetchedFriends
        } catch {
            print("Error fetching friends: \(error)")
        }
    }

    func signUp(email: String, password: String, name: String, gender: User.Gender) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.firebaseUser = result.user
            let user = User(id: result.user.uid, email: email, name: name, gender: gender)
            let encoded = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection(COLLECTION).document(user.id).setData(encoded)
            await fetchUser()
        } catch {
            print(#function, "Error Logging in \(error)")
            throw AUTH_ERROR.SIGNUP_ERROR
        }
    }

    
    func signIn(email : String, password : String) async throws{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.firebaseUser = result.user
            await fetchUser()
           
        } catch {
            throw AUTH_ERROR.LOGIN_ERROR
        }
        
    }
    
    func logout() {
        
        do {
            try Auth.auth().signOut()
            self.firebaseUser = nil
            self.user = nil
        } catch {
            print(#function, "Unable to logout ")
            return
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection(COLLECTION).document(uid).getDocument() else {return}
        self.user = try? snapshot.data(as: User.self)
       
    }
    
    // add an event
        func addEventToFavorites(_ event: Event) {
            guard let user = user else { return }
            var updatedFavorites = user.favourites
            updatedFavorites.append(event)
            updateFavorites(updatedFavorites)
        }
        
        // remove an event
        func removeEventFromFavorites(_ event: Event) {
            guard let user = user else { return }
            var updatedFavorites = user.favourites
            if let index = updatedFavorites.firstIndex(where: { $0.id == event.id }) {
                updatedFavorites.remove(at: index)
                updateFavorites(updatedFavorites)
            }
        }
        
        private func updateFavorites(_ favorites: [Event]) {
            guard let uid = firebaseUser?.uid else { return }
            let userRef = Firestore.firestore().collection(COLLECTION).document(uid)
            do {
                let data: [String: Any] = [
                    FIELD_FAVOURITES: favorites.map { $0.dictionaryRepresentation() }
                ]
                try userRef.setData(data, merge: true)
                self.user?.favourites = favorites
            } catch {
                print("Error updating favorites: \(error.localizedDescription)")
            }
        }
    
    func fetchFavsUser(completion: @escaping ([Event]) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid else {
                completion([])
                return
            }
            
            Firestore.firestore().collection(COLLECTION).document(uid).getDocument { document, error in
                if let error = error {
                    print("Error fetching user's favorites: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let document = document, document.exists else {
                    print("User document does not exist.")
                    completion([])
                    return
                }
                
                do {
                    let user = try document.data(as: User.self)
                    let favorites = user.favourites ?? []
                    completion(favorites)
                } catch {
                    print("Error decoding user's favorites: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }

    extension Event {
        func dictionaryRepresentation() -> [String: Any] {
            return [
                "id": id,
                "venue": [
                    "id": venue.id,
                    "state": venue.state,
                    "name": venue.name,
                    "location": [
                        "lat": venue.location.lat,
                        "lon": venue.location.lon
                    ],
                    "address": venue.address,
                    "country": venue.country,
                    "city": venue.city
                ],
                "title": title,
                "datetime_utc": datetime_utc,
                "description": description,
                "performers": performers.map { $0.dictionaryRepresentation() }
            ]
        }
    }

    extension Performer {
        func dictionaryRepresentation() -> [String: Any] {
        return [
            "image": image
        ]
    }
        
    
    
//    func updateUser(uid:String,name:String) async throws{
//        do {
//            try await Firestore.firestore().collection(COLLECTION_CUSTOMER)
//                .document(uid)
//                .updateData([FIELD_NAME: name])
//
//                //update firebastAuth with new password and email
//                //TODO needs password for confirmation
//
//        } catch {
//            print(#function, "Error Updating User")
//        }
//    }


    }



enum AUTH_ERROR: Error {
case LOGIN_ERROR, SIGNUP_ERROR, CUSTOMER_ERROR
}
