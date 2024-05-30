//
//  UserModel.swift
//  QuitMate
//
//  Created by Саша Василенко on 13.05.2023.
//

import Foundation

enum Currency: String, Hashable, Codable {
    case uah = "₴"
    case usd = "$"
}

struct User: Codable, Identifiable {
    //MARK: - Variables
    var name: String
    var age: String
    var email: String?
    var id: String
    var demands: String
    var expirience: String
    var hourRate: String
    var jobCaterory: JobCategories
    
    //MARK: - Computed properties
//     Unfortunately Firebase Realtime does not support Codable for update operations
    func toDictionary() -> [AnyHashable: Any] {
        var dict: [AnyHashable: Any] = [
            "name": name,
            "age": age,
            "id": id,
            "expirience": expirience,
            "demands": demands
        ]
        
        if let email = email {
            dict["email"] = email
        }
        
//        if let profileImage = profileImage {
//            dict["profileImage"] = profileImage
//        }
        
        return dict
    }
}
//MARK: - Private methods
//extension User {
//    private var startingToFinishingDateDifference: Int {
//        substractTwoDatesInDay(from: startingDate, to: milestoneCompleted ? currentDate : finishingDate)
//    }
//}
