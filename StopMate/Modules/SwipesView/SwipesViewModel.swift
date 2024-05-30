//
//  SwipesViewModel.swift
//  StopMate
//
//  Created by Саша Василенко on 07.05.2024.
//

import Foundation
import Combine

protocol SwipesViewModelProtocol: AnyObject, ObservableObject {
    var jobCategory: JobCategories { get set }
    var data: [User] { get set }
    var vms: [CardViewVM] { get set }
    func swippedLeft(on user: User)
    func getRecommendation(on index: Int)
}


final class SwipesViewModel: SwipesViewModelProtocol {
    
    
    private let storageService: FirebaseStorageServiceProtocol
    private var databaseManager = DatabaseManager.shared
    var didSendEventClosure: ((SwipesViewModel.EventType) -> Void)?
    var selfUser: User = .init(name: "", age: "", id: "", demands: "", expirience: "", hourRate: "", jobCaterory: .other)
    private var selfUserId: String = ""
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        return Sender(photoURL: "",
                      senderId: safeEmail ,
                      displayName: "Me")
    }
    private var disposeBag = Set<AnyCancellable>()
    @Published var jobCategory: JobCategories
    @Published var data: [User] = .init() {
        didSet {
            getSelf()
            generateViewModels()
        }
    }
    @Published var vms: [CardViewVM] = .init()
    init(jobCategory: JobCategories, storageService: FirebaseStorageServiceProtocol) {
        self.jobCategory = jobCategory
        self.storageService = storageService
        
        loadData()
    }
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    private func getSelf() {
        storageService.getUserModel()
        storageService.userDataPublisher.sink { _ in
            print()
        } receiveValue: {[weak self] user in
            guard let user else { return }
            self?.selfUser = user
            self?.selfUserId = user.id
        }.store(in: &disposeBag)
    }
    
    func generateViewModels() {
        vms = []
        for i in data {
            vms.append(CardViewVM(user: i, service: storageService))
        }
    }

    
    func swippedLeft(on user: User) {
        let text = selfUser.demands
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender,
            let messageId = createMessageId(user: user) else {
                return
        }
        let safeNotCurrentEmail = DatabaseManager.safeEmail(emailAddress: user.email!)
        let message = Message(sender: selfSender,
                               messageId: messageId,
                               sentDate: Date(),
                               kind: .text(text))
        databaseManager.createNewConversation(with: safeNotCurrentEmail, name: user.name, firstMessage: message) { _ in
            print("dskalflfkajlfk")
        }
        
        
    }
    
    func getRecommendation(on index: Int) {
        let user = data[index]
        let currentUser = selfUser
        
        print("USER DATA at swipes \(user.name)")
        print("CURRENT USER DATA at swipes \(currentUser.name)")
        
        didSendEventClosure?(.swippedLeft(user, currentUser))
    }
    
    private func createMessageId(user: User) -> String? {
        // date, otherUesrEmail, senderEmail, randomInt
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }

        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        let safeNotCurrentEmail = DatabaseManager.safeEmail(emailAddress: user.email!)

        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(safeNotCurrentEmail)_\(safeCurrentEmail)_\(dateString.replacingOccurrences(of: ".", with: ","))"

        print("created message id: \(newIdentifier)")

        return newIdentifier
    }
    
    private func loadData() {
        storageService.getUsers()
        storageService.users.sink { _ in
            print()
        } receiveValue: { [weak self] users in
            guard let users else { return }
            self?.data = users.filter {
                $0.jobCaterory == self?.jobCategory
            }.filter {
                $0.id != self?.selfUserId
            }

        }.store(in: &disposeBag)

    }
    
    
}

extension SwipesViewModel {
    enum EventType {
        case swippedLeft(User, User)
    }
}
