//
//  CardViewVM.swift
//  StopMate
//
//  Created by Саша Василенко on 12.05.2024.
//

import Foundation
import Combine


protocol CardViewVMProtocol: AnyObject, ObservableObject {
    var user: User { get set }
    var data: Data? { get set }
}


final class CardViewVM: CardViewVMProtocol, Identifiable {
    var user: User
    let service: FirebaseStorageServiceProtocol
    let anotherService: FirebaseStorageService = .init()
    private var disposeBag = Set<AnyCancellable>()
    @Published var data: Data?
    
    init(user: User, service: FirebaseStorageServiceProtocol) {
        self.user = user
        self.service = service
        getPic()
    }
    
    func getPic() {
        anotherService.getUserPicForUser(email: user.email!)
        print(user.id)
        anotherService.anotherUserProfilePicturePublisher.sink { _ in
            print("")
        } receiveValue: {[weak self] result in
            self?.data = result
        }.store(in: &disposeBag)

    }
}
