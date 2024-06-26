//
//  ConversationsModels.swift
//  Messenger
//
//  Created by Ivan Potapenko on 13.12.2021.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}

//
//  ChatModels.swift
//  Messenger
//
//  Created by Ivan Potapenko on 13.12.2021.
//

import Foundation
import CoreLocation
import MessageKit
import UIKit

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_Text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
    
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
}

struct Location: LocationItem{
    var location: CLLocation
    
    var size: CGSize
}


struct SearchResult {
    let name:String
    let email:String
}

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel{
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
