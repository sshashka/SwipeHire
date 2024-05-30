//
//  SearhViewModel.swift
//  StopMate
//
//  Created by Саша Василенко on 07.05.2024.
//

import Foundation



protocol SearchViewModelProtocol: AnyObject, ObservableObject {
    var jobCategories: [JobCategories] { get }
    var selectedCategory: JobCategories? { get set }
    func didTapOnDone()
}


final class SearchViewModel: SearchViewModelProtocol {
    var didSendEventClosure: ((SearchViewModel.EventType) -> Void)?
    
    @Published var jobCategories: [JobCategories] = JobCategories.allCases
    @Published var selectedCategory: JobCategories?
    
    func didTapOnDone() {
        guard let selectedCategory else { return }
        self.didSendEventClosure?(.done(selectedCategory))
    }
    
}


extension SearchViewModel {
    enum EventType {
        case done(JobCategories)
    }
}
