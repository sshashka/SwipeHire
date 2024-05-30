//
//  TabBarPages.swift
//  QuitMate
//
//  Created by Саша Василенко on 07.04.2023.
//
import UIKit

enum TabBarPages {
    case search, chats, settings
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .search
        case 1:
            self = .chats
        case 2:
            self = .settings
        default:
            return nil
        }
    }
    
    func getImages() -> UIImage {
        switch self {
        case .search:
            return UIImage(systemName: "magnifyingglass")!
        case .chats:
            return UIImage(systemName: "message")!
        case .settings:
            return UIImage(systemName: "gear")!
        }
    }
}
