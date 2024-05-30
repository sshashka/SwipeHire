//
//  SettingsViewModel.swift
//  QuitMate
//
//  Created by Саша Василенко on 12.05.2023.
//

import Foundation
import Combine
import FirebaseAuth

protocol SettingsViewModelProtocol: AnyObject {
    var isShowingAlert: Bool { get set }
    var errorText: String { get }
    var userModel: User? { get }
    // TODO: replace HeaderViewViewModel with HeaderViewViewModelProtocol
    var headerViewModel: HeaderViewViewModel { get }
    var isShowingAlertPublisher: Published<Bool>.Publisher { get }
    func didTapOnOnboarding()
    func didTapLogout()
    
    func updateUserProfilePic()
    func resetPassword()
    func didAppear()
    func didTapOnEdit()
    func didTapOnAccountDelete()
}

final class SettingsViewModel: ObservableObject, SettingsViewModelProtocol {
    
    @Published var isShowingAlert: Bool = false
    var isShowingAlertPublisher: Published<Bool>.Publisher { $isShowingAlert }
    
    private var disposeBag = Set<AnyCancellable>()

    private let storageService: FirebaseStorageServiceProtocol
    private let authService: AuthentificationServiceProtocol
    
    private (set) var errorText: String = ""
    
    
    var didSendEventClosure: ((SettingsViewModel.EventType) -> Void)?
    
    
    @Published var userModel: User? {
        didSet {
            getViewModels()
            guard let userEmail = userModel?.email else { return }
            storageService.retrieveUserProfilePic(userEmail: userEmail)
        }
    }
    
    func didAppear() {
        guard let userEmail = userModel?.email else { return }
        storageService.retrieveUserProfilePic(userEmail: userEmail)
//        getUserProfilePic()
    }
    
    @Published private var userProfilePic: Data? {
        didSet {
            updateUserProfilePic()
        }
    }
    
    @Published var headerViewModel: HeaderViewViewModel
    
    init(storageService: FirebaseStorageServiceProtocol, authService: AuthentificationServiceProtocol) {
        self.storageService = storageService
        self.authService = authService
        let user: User = .init(name: "", age: "", email: "", id: "", demands: "", expirience: "", hourRate: "", jobCaterory: .iOS)
        self.headerViewModel = HeaderViewViewModel(user: user)
        getUserModel()
        getUserProfilePic()        
    }
    
    private func getUserModel() {
//        storageService.userPublisher
        storageService.userDataPublisher
            .sink {
                print($0)
            } receiveValue: {[weak self] in
                self?.userModel = $0
            }.store(in: &disposeBag)
    }
    
    
    
    private func getUserProfilePic() {

//        storageService.retrieveUserProfilePic(userEmail: userEmail)
        storageService.userProfilePicturePublisher
            .sink { error in
            print(error)
        } receiveValue: { [weak self] data in
            self?.userProfilePic = data
            self?.updateUserProfilePic()
        }.store(in: &disposeBag)
    }
    
    func didTapOnOnboarding() {
        didSendEventClosure?(.didTapOnOnboarding)
    }
    
    func didTapLogout() {
        // Fix
        try? Auth.auth().signOut()
    }
    
    
    func getViewModels() {
        guard let user = userModel else { return }
        headerViewModel.updateWith(user: user)
    }
    
    func updateUserProfilePic() {
        headerViewModel.updatePhoto(image: userProfilePic)
//        getUserProfilePic()
    }
    
    func resetPassword() {
        authService.resetPassword()
    }
    
    func didTapOnEdit() {
        didSendEventClosure?(.didTapOnEdit)
    }
    
    func didTapOnAccountDelete() {
        authService.deleteAccount()
    }
}

extension SettingsViewModel {
    enum EventType {
        case didTapOnNewMood, didTapOnHistory, didTapOnEdit, didTapOnOnboarding
    }
}
