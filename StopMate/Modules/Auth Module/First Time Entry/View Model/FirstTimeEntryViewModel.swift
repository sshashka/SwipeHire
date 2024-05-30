//
//  FIrstTimeEntryViewModel.swift
//  QuitMate
//
//  Created by Саша Василенко on 15.06.2023.
//

import Combine
import Foundation
import FirebaseAuth
import UIKit

protocol FirstTimeEntryViewModelProtocol: AnyObject, ObservableObject {
    var name: String { get set }
    var age: String { get set }
    var expirience: String { get set }
    var hourRate: String { get set }
    var demands: String { get set }
    var selectedCategory: JobCategories? { get set }
    func didTapOnFinish()
}

final class FirstTimeEntryViewModel: FirstTimeEntryViewModelProtocol {
    let storageService: FirebaseStorageServiceProtocol
    var didSendEventClosure: ((FirstTimeEntryViewModel.EventType) -> Void)?
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var expirience: String = ""
    @Published var hourRate: String = ""
    @Published var selectedCategory: JobCategories?
    @Published var demands: String = ""
    private var databaseManager = DatabaseManager.shared
    
    init (storageService: FirebaseStorageServiceProtocol) {
        self.storageService = storageService
    }
    
    func didTapOnFinish() {
        let id = Auth.auth().currentUser?.uid
        let email = Auth.auth().currentUser?.email
        guard let email else { return }
        guard let id = id else { return }
        guard let selectedCategory else { return }
        let user: User = .init(name: name, age: age, email: email, id: id, demands: demands, expirience: expirience, hourRate: hourRate, jobCaterory: selectedCategory)
        storageService.createNewUser(userModel: user)
        let image = UIImage(resource: .noProfilePic).pngData()
        guard let image = image else { return }
        storageService.updateUserProfilePic(with: image, for: email)
        databaseManager.insertUser(with: ChatAppUser(firstName: name, lastName: name, emailAddress: email)) { _ in
            print("kek")
        }
        didSendEventClosure?(.end)
    }
    
//    var ageIsValid: AnyPublisher<Bool, Never> {
//        return Int(age) ?? false >= 18
//    }
}

extension FirstTimeEntryViewModel {
    enum EventType {
        case end
    }
}
