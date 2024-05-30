//
//  FirebaseStorageService.swift
//  QuitMate
//
//  Created by Саша Василенко on 28.04.2023.
//
import Combine
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

fileprivate enum FirebaseStorageServiceReferences: String {
    case youtubeApiKey = "YoutubeApiKey"
    case aiKey = "AIKey"
    case moods = "User-Moods"
    case user = "User"
    case history = "History"
    case moodDates = "User-Moods-Dates"
    case userSmoked = "User-Smoked"
}

protocol FirebaseStorageServicePublishersProtocol: AnyObject {
    var userDataPublisher: CurrentValueSubject<User?, Error> { get }
    var userProfilePicturePublisher: CurrentValueSubject<Data?, Error> { get }
    var userMoodDates: CurrentValueSubject<Date?, Error> { get }
    var users: CurrentValueSubject<[User]?, Error> { get }
    var anotherUserProfilePicturePublisher: CurrentValueSubject<Data?, Error> { get }
}

protocol FirebaseStorageServiceSecurityProtocol: AnyObject {
    func getYoutubeApiKey(completion: @escaping(String) -> Void)
    func getAiKey(completion: @escaping(String) -> Void)
}

protocol FirebaseStorageServiceProtocol: FirebaseStorageServicePublishersProtocol, FirebaseStorageServiceSecurityProtocol {
    func createNewUser(userModel: User)
    func getUserModel()
    func updateUserFinishingDate(with date: Date)
    func retrieveUserProfilePic(userEmail: String)
    func getUsers()
    //    func addRecordToUserHistory(record: UserHistoryModel)
    func updateUserProfilePic(with: Data, for userEmail: String)
    //    func getUserHistory() -> AnyPublisher<[UserHistoryModel], Error>
    func updateUserProfileData(user: User)
    func checkIfUserExists(userId: String, completion: @escaping(Bool) -> Void)
    func getUserPicForUser(email: String)
    //    func retrieveUserProfilePic()
    //    func updateUserOnboardingStatus()
    //    func getUserSmokingSessionMetrics()
}

final class FirebaseStorageService: FirebaseStorageServiceProtocol {

    var userProfilePicturePublisher = CurrentValueSubject<Data?, Error>(nil)
    var anotherUserProfilePicturePublisher = CurrentValueSubject<Data?, Error>(nil)
    
    var cancellables = Set<AnyCancellable>()
    
    var userDataPublisher = CurrentValueSubject<User?, Error>(nil)
    
    var userMoodDates = CurrentValueSubject<Date?, Error>(nil)
    
    var users = CurrentValueSubject<[User]?, Error>(nil)
    
    func getUsers() {
        let reference = getChildReference(for: .user)
        
        reference.observe(.value) { [weak self] snapshot, error in
            if let error = error {
                self?.users.send(completion: .failure(error as! Error))
            } else if let children = snapshot.children.allObjects as? [DataSnapshot] {
                let dataForCharts = children.compactMap { snapshot in
                    try? snapshot.data(as: User.self)
                }
                self?.users.send(dataForCharts)
            }
        }
    }
    
    // MARK: getting Child references
    private lazy var userId: String? = {
        let id = UserDefaults.standard.string(forKey: UserDefaultsConstants.userId)
        return id
    }()
    
    private lazy var userEmail: String? = {
        let id = UserDefaults.standard.string(forKey: "email")
        return id
    }()
    
    private func getChildReference(for path: FirebaseStorageServiceReferences) -> DatabaseReference {
        return Database.database().reference(withPath: path.rawValue)
    }
    
    private func getChildReferenceWithUserId(for path: FirebaseStorageServiceReferences) -> DatabaseReference {
        if let userId {
            return getChildReference(for: path).child(userId)
        }
        return DatabaseReference()
    }
    
    private func getReferenceForUserProfilePicture(userEmail: String) -> StorageReference? {
//        guard let userEmail else { return nil }
        
        
            let safeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
            return Storage.storage().reference().child("images/\(safeEmail)_profile_picture.png")
        
        
    }
    // MARK: Getiing user moods and charts
    
    
    
    // MARK: Working with user-related data
    func createNewUser(userModel: User) {
        let reference = getChildReferenceWithUserId(for: .user)
        try? reference.setValue(from: userModel)
    }
    
    func updateUserFinishingDate(with date: Date) {
        // Interestingly enough either firebase or apple uses 2001 timeinterval in codable rather than 1970
        let dateFormatted = date.timeIntervalSinceReferenceDate
        
        let reference = getChildReferenceWithUserId(for: .user)
        reference.updateChildValues(["finishingDate" : Int(dateFormatted)])
    }
    
    func getUserModel() {
        let reference = getChildReferenceWithUserId(for: .user)
        reference.observe(.value) {[weak self] snapshot, error in
            if let error = error {
                self?.userDataPublisher.send(completion: .failure(error as! Error))
            } else if (snapshot.value as Any?) != nil {
                let user = try? snapshot.data(as: User.self)
                if let user = user {
                    self?.userDataPublisher.send(user)
                }
            }
        }
    }
    
    
//    func createNewChannelForUser(userToAdd: String) {
//        let reference = Storage.storage().reference().child(UserDefaults.standard.string(forKey: UserDefaultsConstants.userId)!)
//    }
    
    func updateUserProfilePic(with image: Data, for userEmail: String) {
        let reference = getReferenceForUserProfilePicture(userEmail: userEmail)
        guard let reference else { return }
        let imageCompressed = image.compressImage(maxSizeMB: 3)
        let uploadTask = reference.putData(imageCompressed ?? Data())
        uploadTask.observe(.success) { [weak self] _ in
//            self?.retrieveUserProfilePic(userEmail: userEmail)
        }
    }
    
    func retrieveUserProfilePic(userEmail: String) {
        let reference = getReferenceForUserProfilePicture(userEmail: userEmail)
        guard let reference else { return }
        reference.getData(maxSize: 3 * 1024 * 1024) {[weak self] data, error in
            if let error = error {
                self?.userProfilePicturePublisher.send(completion: .failure(error))
            } else {
                self?.userProfilePicturePublisher.send(data)
            }
        }
        
    }
    
    
    func getUserPicForUser(email: String) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let reference = Storage.storage().reference().child("images/\(safeEmail)_profile_picture.png")
        print(reference)
        reference.getData(maxSize: 3 * 1024 * 1024) {[weak self] data, error in
            if let error = error {
                self?.anotherUserProfilePicturePublisher.send(completion: .failure(error))
            } else {
                self?.anotherUserProfilePicturePublisher.send(data)
            }
        }
    }
    
        func updateUserProfileData(user: User) {
            let reference = getChildReferenceWithUserId(for: .user)
            reference.updateChildValues(user.toDictionary())
        }
    
    func updateUserOnboardingStatus() {
        let reference = getChildReferenceWithUserId(for: .user)
        reference.updateChildValues(["didCompleteTutorial" : true])
    }
    
    //    func addUserSmokingSessionMetrics(entry: UserSmokingSessionMetrics) {
    //        let reference = getChildReferenceWithUserId(for: .userSmoked).childByAutoId()
    //        try? reference.setValue(from: entry)
    //    }
    
    //    func getUserSmokingSessionMetrics() {
    //        let reference = getChildReferenceWithUserId(for: .userSmoked)
    //        reference.observe(.value) {[weak self] snapshot, error in
    //            if let error = error {
    //                self?.userSmokingSessionMetricsSubject.send(completion: .failure(error as! Error))
    //            } else if let children = snapshot.children.allObjects as? [DataSnapshot] {
    //                let data = children.compactMap { snapshot in
    //                    try? snapshot.data(as: UserSmokingSessionMetrics.self)
    //                }
    //                self?.userSmokingSessionMetricsSubject.send(data)
    //            }
    //        }
    //    }
    
    // MARK: Working with user history of recomendations
    //    func getUserHistory() -> AnyPublisher<[UserHistoryModel], Error> {
    //        let reference = getChildReferenceWithUserId(for: .history)
    //        let subject = PassthroughSubject<[UserHistoryModel], Error>()
    //
    //        reference.observe(.value) { snapshot, error in
    //            if let error = error {
    //                subject.send(completion: .failure(error as! Error))
    //            } else if let children = snapshot.children.allObjects as? [DataSnapshot] {
    //                let dataForCharts = children.compactMap { snapshot in
    //                    try? snapshot.data(as: UserHistoryModel.self)
    //                }
    //
    //                subject.send(dataForCharts)
    //            }
    //        }
    //        return subject.eraseToAnyPublisher()
    //    }
    
    //    func addRecordToUserHistory(record: UserHistoryModel) {
    //        let reference = getChildReferenceWithUserId(for: .history).childByAutoId()
    //        try? reference.setValue(from: record)
    //    }
    //    // MARK: Checing if user exists
    func checkIfUserExists(userId: String, completion: @escaping(Bool) -> Void) {
        let reference = getChildReference(for: .user).child(userId)
        reference.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //    func checkIfUserCompletedOnboarding(completion: @escaping(Bool) -> Void) {
    //        let reference = getChildReferenceWithUserId(for: .user)
    //        reference.observeSingleEvent(of: .value) { snapshot in
    //            let user = try? snapshot.data(as: User.self)
    //            if let user {
    //                completion(user.didCompleteTutorial)
    //            }
    //        }
    //    }
    
    //MARK: Getting api keys
    func getYoutubeApiKey(completion: @escaping(String) -> Void) {
        let reference = getChildReference(for: .youtubeApiKey)
        reference.observe(.value) { snapshot in
            let reference = try? snapshot.data(as: String.self)
            if let reference {
                completion(reference)
            }
        }
    }
    
    func getAiKey(completion: @escaping(String) -> Void) {
        let reference = getChildReference(for: .aiKey)
        reference.observe(.value) { snapshot in
            let reference = try? snapshot.data(as: String.self)
            if let reference {
                completion(reference)
            }
        }
    }
}


private extension FirebaseStorageService {
    // To reduce boilerplate code
    func observeChild<T: Codable>(at reference: FirebaseStorageServiceReferences, for type: T, publisher: CurrentValueSubject<[T]?, Error>) {
        let reference = getChildReference(for: reference)
        reference.observe(.value) { snapshot, error in
            if let error = error {
                publisher.send(completion: .failure(error as! Error))
            } else if let children = snapshot.children.allObjects as? [DataSnapshot] {
                let data = children.compactMap { snapshot in
                    try? snapshot.data(as: T.self)
                }
                publisher.send(data)
            }
        }
    }
}
