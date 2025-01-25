//
//  FirebaseDBHelper.swift
//  Group_06_Events
//
//  Created by Darren Eddy on 2024-03-11.
//

import Foundation


import Foundation
import FirebaseFirestore
import Firebase

class FireDBHelper : ObservableObject{
    
    @Published var events = [Event]()
    
    private let db : Firestore
    private static var shared : FireDBHelper?
    
    private let COLLECTION_EVENT : String = "Event"
    private let FIELD_NAME : String = "name"
    private let FIELD_LOCATION : String = "location"
    private let FIELD_DATE : String = "date"
    private let FIELD_ATTENDING : String = "attending"
    
    init(){
        self.db = Firestore.firestore()
    }
    
    static func getInstance() -> FireDBHelper{
        if (shared == nil){
            shared = FireDBHelper()
        }
        return shared!
    }
    
//    func insertEvent(newEvent: Event){
//        do{
//            let data = try Firestore.Encoder().encode(newEvent)
//            self.db.collection(COLLECTION_EVENT).document(newEvent.id).setData(data)
//            }
//        catch let err as NSError{
//                print(#function, "Unable to add document to firestore : \(err)")
//        }
//    }
//
//    func getAllEvents(){
//
//            self.db.collection(COLLECTION_EVENT)
//                .addSnapshotListener({ (querySnapshot, error) in
//
//                    guard let snapshot = querySnapshot else{
//                        print(#function, "Unable to retrieve data from firestore : \(String(describing: error))")
//                        return
//                    }
//
//                    snapshot.documentChanges.forEach{ (docChange) in
//
//                        do{
//
//                            var event : Event = try docChange.document.data(as: Event.self)
//                            event.id = docChange.document.documentID
//
//                            let matchedIndex = self.events.firstIndex(where: {($0.id.elementsEqual(docChange.document.documentID))})
//
//                            switch(docChange.type){
//                            case .added:
//                                print(#function, "Document added : \(docChange.document.documentID)")
//                                self.events.append(event)
//                            case .modified:
//                                //replace existing object with updated one
//                                print(#function, "Document updated : \(docChange.document.documentID)")
//                                if (matchedIndex != nil){
//                                    self.events[matchedIndex!] = event
//                                }
//                            case .removed:
//                                //remove object from index in bookList
//                                print(#function, "Document removed : \(docChange.document.documentID)")
//                                if (matchedIndex != nil){
//                                    self.events.remove(at: matchedIndex!)
//                                }
//                            }
//
//                        }catch let err as NSError{
//                            print(#function, "Unable to convert document into Swift object : \(err)")
//                        }
//
//                    }//forEach
//                })//addSnapshotListener
//
//    }//getAllBooks
//
//    func deleteEvent(eventToDelete : Event){
//
//            self.db.collection(COLLECTION_EVENT)
//                .document(eventToDelete.id)
//                .delete{error in
//                    if let err = error{
//                        print(#function, "Unable to delete document : \(err)")
//                    }else{
//                        print(#function, "successfully deleted: \(eventToDelete)")
//                    }
//                }
//
//    }
//
//    func updateEvent(eventToUpdate : Event){
//
//            self.db.collection(COLLECTION_EVENT)
//                .document(eventToUpdate.id)
//                .updateData([FIELD_ATTENDING: eventToUpdate.attending]){ error in
//
//                    if let err = error{
//                        print(#function, "Unable to update document : \(err)")
//                    }else{
//                        print(#function, "successfully updated : \(eventToUpdate.title)")
//                    }
//                }
//    }
}
