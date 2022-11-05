//
//  ViewModel.swift
//  Awards
//
//  Created by Mihnea on 7/24/22.
//

import Foundation
import FirebaseStorage
import UIKit
import Firebase


var dbMonthly = [dbAward]()
var dbCompetitions = [dbAward]()
var dbLimited = [dbAward]()
var dbClose = [dbAward]()


class ViewModel : ObservableObject {
    func getData(completion: (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("2022MonthlyChallenges").getDocuments { snapshot, err in
            if let err = err {
                print(err)
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        dbMonthly = snapshot.documents.map({ d in
                            return dbAward(id: d.documentID, name: d["name"] as? String ?? "", imgPath: d["imgPath"] as? String ?? "", collection: d["collection"] as? String ?? "", image: Data(), orderNo: d["orderNo"] as! Int)
                        })
                    }
                }
            }
        }
        
        db.collection("Competitions").getDocuments { snapshot, err in
            if let err = err {
                print(err)
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        print("DSFKDFSKMDSFMK")
                        dbCompetitions = snapshot.documents.map({ d in
                            return dbAward(id: d.documentID, name: d["name"] as? String ?? "", imgPath: d["imgPath"] as? String ?? "", collection: d["collection"] as? String ?? "", image: Data(), orderNo: d["orderNo"] as! Int)
                        })
                    }
                }
            }
        }
        
        db.collection("2022LimitedEdition").getDocuments { snapshot, err in
            if let err = err {
                print(err)
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        print("DSFKDFSKMDSFMK")
                        dbLimited = snapshot.documents.map({ d in
                            return dbAward(id: d.documentID, name: d["name"] as? String ?? "", imgPath: d["imgPath"] as? String ?? "", collection: d["collection"] as? String ?? "", image: Data(), orderNo: d["orderNo"] as! Int)
                        })
                    }
                }
            }
        }
        
        db.collection("CloseYourRings").getDocuments { snapshot, err in
            if let err = err {
                print(err)
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        print("DSFKDFSKMDSFMK")
                        dbClose = snapshot.documents.map({ d in
                            return dbAward(id: d.documentID, name: d["name"] as? String ?? "", imgPath: d["imgPath"] as? String ?? "", collection: d["collection"] as? String ?? "", image: Data(), orderNo: d["orderNo"] as! Int)
                        })
                    }
                }
            }
        }
        
        completion(true)
    }
    
    func retrieveImg(completion1: (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("2022MonthlyChallenges").getDocuments { snapshot, err in
            guard err == nil && snapshot != nil else {
                print("ERROR ERROR ERROR")
                return
            }
            var paths = [String]()
            for doc in snapshot!.documents {
                paths.append(doc["imgPath"] as! String)
            }
            print(paths)
            DispatchQueue.main.async {
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    fileRef.getData(maxSize: (2*1024*1024)) { data, err in
                        guard err == nil && data != nil else {return}
                        let index = dbMonthly.firstIndex(where: {$0.imgPath.contains(path)})!
                        dbMonthly[index].image = data!
                    }
                }
            }
        }
        
        db.collection("Competitions").getDocuments { snapshot, err in
            guard err == nil && snapshot != nil else {
                print("ERROR ERROR ERROR")
                return
            }
            var paths = [String]()
            for doc in snapshot!.documents {
                paths.append(doc["imgPath"] as! String)
            }
            print(paths)
            DispatchQueue.main.async {
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    fileRef.getData(maxSize: (2*1024*1024)) { data, err in
                        guard err == nil && data != nil else {return}
                        let index = dbCompetitions.firstIndex(where: {$0.imgPath.contains(path)})!
                        dbCompetitions[index].image = data!
                    }
                }
            }
        }
        
        db.collection("2022LimitedEdition").getDocuments { snapshot, err in
            guard err == nil && snapshot != nil else {
                print("ERROR ERROR ERROR")
                return
            }
            var paths = [String]()
            for doc in snapshot!.documents {
                paths.append(doc["imgPath"] as! String)
            }
            print(paths)
            DispatchQueue.main.async {
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    fileRef.getData(maxSize: (2*1024*1024)) { data, err in
                        guard err == nil && data != nil else {return}
                        let index = dbLimited.firstIndex(where: {$0.imgPath.contains(path)})!
                        dbLimited[index].image = data!
                    }
                }
            }
        }
        
        db.collection("CloseYourRings").getDocuments { snapshot, err in
            guard err == nil && snapshot != nil else {
                print("ERROR ERROR ERROR")
                return
            }
            var paths = [String]()
            for doc in snapshot!.documents {
                paths.append(doc["imgPath"] as! String)
            }
            print(paths)
            DispatchQueue.main.async {
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    fileRef.getData(maxSize: (2*1024*1024)) { data, err in
                        guard err == nil && data != nil else {return}
                        let index = dbClose.firstIndex(where: {$0.imgPath.contains(path)})!
                        dbClose[index].image = data!
                    }
                }
            }
        }
        
        completion1(true)
    }

}
