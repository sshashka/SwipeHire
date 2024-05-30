////
////  Message.swift
////  StopMate
////
////  Created by Саша Василенко on 11.05.2024.
////
//
//import Foundation
//import FirebaseFirestore
//import FirebaseCore
//import FirebaseDatabase
//public struct Message: Identifiable, Hashable {
//    public static func == (lhs: Message, rhs: Message) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    public enum Status: Equatable, Hashable {
//        case sending
//        case sent
//        case read
//    }
//
//    public var id: String
//    var user: User
//    public var status: Status?
//    public var createdAt: Date
//    public var text: String
//}
//
//public struct FirestoreMessage: Codable, Hashable {
//    @DocumentID public var id: String?
//    public var userId: String
//    @ServerTimestamp public var createdAt: Date?
//
//    public var text: String
//}
