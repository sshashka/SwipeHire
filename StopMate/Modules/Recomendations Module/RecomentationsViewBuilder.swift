//
//  RecomentationsViewBuilder.swift
//  StopMate
//
//  Created by Саша Василенко on 24.11.2023.
//

import SwiftUI
import UIKit

final class RecomentationsViewBuilder {
    static func build(user: User, currentUser: User) -> Module<UIViewController, RecomendationsViewModel> {
        let vm = RecomendationsViewModel(user: user, currentUser: currentUser)
        let vc = UIHostingController(rootView: RecomendationsView(viewModel: vm))
        return Module(viewController: vc, viewModel: vm)
    }
}


//
//  Module.swift
//  StopMate
//
//  Created by Саша Василенко on 21.11.2023.
//

import UIKit

struct Module<V: UIViewController, VM: ViewModelBaseProtocol> {
    let viewController: V
    let viewModel: VM
}

//
//  ViewModelBaseProtocol.swift
//  StopMate
//
//  Created by Саша Василенко on 23.11.2023.
//

import Foundation

protocol ViewModelBaseProtocol: Any { }
