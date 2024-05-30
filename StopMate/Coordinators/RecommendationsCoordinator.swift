//
//  RecommendationsCoordinator.swift
//  StopMate
//
//  Created by Саша Василенко on 13.05.2024.
//

import UIKit
import SwiftUI

protocol RecomendationsCoordinatorProtocol: Coordinator {
    func showRecomendationsView()
}

final class RecomendationsCoordinator: RecomendationsCoordinatorProtocol {
    func showRecomendationsView() {
        let storageService = FirebaseStorageService()
        let viewModel = RecomendationsViewModel(user: user, currentUser: currnetUser)
        let recomendationsVC = UIHostingController(rootView: RecomendationsView(viewModel: viewModel))
        viewModel.didSendEventClosure = { [weak self] event in
            self?.finish()
        }
        navigationController.pushViewController(recomendationsVC, animated: true)
    }
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var user: User = .init(name: "", age: "", id: "", demands: "", expirience: "", hourRate: "", jobCaterory: .other)
    
    var currnetUser: User = .init(name: "", age: "", id: "", demands: "", expirience: "", hourRate: "", jobCaterory: .other)
    
    var navigationController: UINavigationController
    
    var recomendationType: RecomendationsViewModel.TypeOfRecomendation = .moodRecomendation
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .recomendations }
    
    func start() {
        showRecomendationsView()
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
