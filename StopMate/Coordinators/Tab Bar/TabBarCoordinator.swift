//
//  TabBarCoordinator.swift
//  QuitMate
//
//  Created by Саша Василенко on 07.04.2023.
//

import UIKit
import SwiftUI

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get }
}

final class TabBarCoordinator: NSObject, Coordinator {
    private var storageService = FirebaseStorageService()
    private var authService = FirebaseAuthentificationService()
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .tabbar }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
        
    }
    
    func start() {
        let pages: [TabBarPages] = [.search, .chats, .settings]
        navigationController.setNavigationBarHidden(true, animated: true)
        
        let controllers: [UINavigationController] = pages.map {getTabControllers(page: $0)}
        
        setupTabBar(controllers: controllers)
    }
    
    
    private func showRecommendation(user: User, currentUser: User, navVC: UINavigationController) {
        let coordinator = RecomendationsCoordinator(navVC)
        print("USER DATA at coord \(user.name)")
        print("CURRENT USER DATA at coord \(currentUser.name)")
        coordinator.user = user
        coordinator.currnetUser = currentUser
        childCoordinators.append(coordinator)
        coordinator.finishDelegate = self.finishDelegate
        coordinator.start()
    }
    
    private func showSearchResults(_ category: JobCategories, navigationController: UINavigationController) {
        let vm = SwipesViewModel(jobCategory: category, storageService: storageService)
        let vc = SwipesView(viewModel: vm)
        navigationController.pushViewController(UIHostingController(rootView: vc), animated: true)
        vm.didSendEventClosure = { [weak self] event in
            switch event {
            case let .swippedLeft(user, currentUSer):
                self?.showRecommendation(user: user, currentUser: currentUSer, navVC: navigationController)
                print("User\(user.name)")
            }
        }
        
    }
    
    private func showReasonsToStop() {
        self.replaceWithNewCoordinator(coordinator: .reasonsToStop)
    }
    
    private func getTabControllers(page: TabBarPages) -> UINavigationController {
        let navVC = UINavigationController()
        navVC.tabBarItem = UITabBarItem.init(title: nil, image: page.getImages(), selectedImage: nil)
        navVC.setNavigationBarHidden(false, animated: false)
        switch page {
        case .chats:
            
            let vc = ConversationsViewController()
            navVC.pushViewController(vc, animated: true)
//            let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
//                                                  secondaryColor: UIColor(hexString: "#f0f0f0"),
//                                                  inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
//                                                  inputTextViewTextColor: .black,
//                                                  inputPlaceholderTextColor: UIColor(hexString: "#979797"))
//            let channel = ATCChatChannel(id: "channel_id", name: "Chat Title")
//            let viewer = ATCUser(firstName: "Florian", lastName: "Marcu")
//            let chatVC = ATCChatThreadViewController(user: viewer, channel: channel, uiConfig: uiConfig)
//
//            // Present the chatVC view controller
//
//            navVC.pushViewController(chatVC, animated: true)
            
        case .settings:
            let coordinator = SettingsCoordinator(navVC)
            childCoordinators.append(coordinator)
            coordinator.finishDelegate = self.finishDelegate
            coordinator.start()
            coordinator.didSendEventClosure = { [weak self] child in
                self?.childCoordinators = self?.childCoordinators.filter({ $0.type != child.type }) ?? []
            }
        case .search:
            let searchVM = SearchViewModel()
            searchVM.didSendEventClosure = { [weak self] event in
                switch event {
                case let .done(category):
                    self?.showSearchResults(category, navigationController: navVC)
                }
            }
            let vc = UIHostingController(rootView: SearchView(viewModel: searchVM))
            navVC.pushViewController(vc, animated: true)
//        case .charts:
//            let chartsVM = ProgressChartsViewModel(storageService: storageService)
//            chartsVM.didSendEventClosure = { [weak self] event in
//                switch event {
//                case .newMood:
//                    self?.finishDelegate?.instantiateNewCoordinator(coordinator: .moodClassifier)
//                }
//            }
//            let vc = UIHostingController(rootView: ProgressChartsView(viewModel: chartsVM))
//            navVC.pushViewController(vc, animated: true)
//        case .home:
//            storageService.getUserModel()
//            let vm = MainScreenViewModel(storageService: storageService)
//            let mainView = MainScreenView(viewModel: vm)
//            vm.didSendEventClosure = { [weak self] event in
//                switch event {
//                case .didTapResetButton:
//                    self?.showReasonsToStop()
//                case .didTapOnSettings:
//                    self?.showSettings(navigationVC: navVC)
//                case .milestoneCompleted:
//                    self?.showMilestoneCompletedView()
//                }
//            }
//            let hostingVC = UIHostingController(rootView: mainView)
//            navVC.pushWithCustomAnination(hostingVC)
//        case .videos:
//            let youtubeService = YoutubeApiService()
//            let viewModel = VideoSelectionViewModel(youtubeService: youtubeService)
//            let videosVC = UIHostingController(rootView: VideoSelectionView(viewModel: viewModel))
//            viewModel.didSendEvetClosure = { [weak self] event in
//                switch event {
//                case .didSelectVideo(let id):
//                    self?.showVideoInfo(for: id, navigationVC: navVC)
//                }
//            }
//            navVC.navigationBar.prefersLargeTitles = true
//            navVC.pushViewController(videosVC, animated: true)
        }
        return navVC
    }
    
//    private func showMilestoneCompletedView() {
//        let vm = MilestoneCompletedViewModel()
//        let vc = UIHostingController(rootView: MilestoneCompletedView(vm: vm))
//        
//        vc.view.backgroundColor = UIColor(resource: .background)
//        vm.didSendEvent = { [weak self] event in
//            switch event {
//            case .dontChangeAnything:
//                vc.dismiss(animated: true)
//            case .resetFinishingDate:
//                vc.dismiss(animated: true)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self?.showReasonsToStop()
//                }
//            }
//        }
//        navigationController.present(vc, animated: true)
//    }
    
//    private func showVideoInfo(for id: String, navigationVC: UINavigationController) {
//        let vm = VideoInfoViewModel(youtubeService: YoutubeApiService(), id: id)
//        vm.didSendEventClosure = { [weak self] event in
//            switch event {
//            case .loadVideo(let id):
//                self?.showVideo(id: id, navigationVC: navigationVC)
//            case .willAppear:
//                navigationVC.navigationBar.prefersLargeTitles = false
//            case .willDisappear:
//                navigationVC.navigationBar.prefersLargeTitles = true
//            }
//        }
//        let vc = UIHostingController(rootView: VideoInfoView(vm: vm))
//        vc.title = nil
//        navigationVC.pushViewController(vc, animated: true)
//    }
//    
//    private func showVideo(id: String, navigationVC: UINavigationController) {
//        let vc = YoutubePlayer()
//        vc.videoID = id
//        navigationVC.pushViewController(vc, animated: true)
//    }
    
//    private func showSettings(navigationVC: UINavigationController) {
//        let coordinator = SettingsCoordinator(navigationVC)
//        childCoordinators.append(coordinator)
//        coordinator.finishDelegate = self.finishDelegate
//        coordinator.start()
//        coordinator.didSendEventClosure = { [weak self] child in
//            self?.childCoordinators = self?.childCoordinators.filter({ $0.type != child.type }) ?? []
//        }
//    }
    
    private func setupTabBar(controllers tabController: [UIViewController]) {
        tabBarController.tabBar.tintColor = UIColor(named: ColorConstants.buttonsColor)
        tabBarController.setViewControllers(tabController, animated: true)
        tabBarController.selectedIndex = 1
        navigationController.viewControllers = [tabBarController]
    }
}
