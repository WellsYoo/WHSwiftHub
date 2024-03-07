//
//  HomeTabBarViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/11/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhatsNewKit

class HomeTabBarViewModel: ViewModel, ViewModelType {

    struct Input {
        let whatsNewTrigger: Observable<Void>
    }

    struct Output {
        let tabBarItems: Driver<[HomeTabBarItem]>
        let openWhatsNew: Driver<WhatsNewBlock>
    }

    let authorized: Bool
    let whatsNewManager: WhatsNewManager

    init(authorized: Bool, provider: SwiftHubAPI) {
        self.authorized = authorized
        whatsNewManager = WhatsNewManager.shared
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {

        let tabBarItems = Observable.just(authorized).map { (authorized) -> [HomeTabBarItem] in
            if authorized {
                return [.news, .search, .notifications, .settings]
            } else {
                return [.search, .login, .settings]
            }
        }.asDriver(onErrorJustReturn: [])

        let whatsNew = whatsNewManager.whatsNew()
        let whatsNewItems = input.whatsNewTrigger.take(1).map { _ in whatsNew }

        return Output(tabBarItems: tabBarItems,
                      openWhatsNew: whatsNewItems.asDriverOnErrorJustComplete())
    }

    func viewModel(for tabBarItem: HomeTabBarItem) -> ViewModel {
        switch tabBarItem {
        case .search:
            let viewModel = SearchViewModel(provider: provider)
            return viewModel
        case .news:
            let user = User.currentUser()!
            let viewModel = EventsViewModel(mode: .user(user: user), provider: provider)
            return viewModel
        case .notifications:
            let viewModel = NotificationsViewModel(mode: .mine, provider: provider)
            return viewModel
        case .settings:
            let viewModel = SettingsViewModel(provider: provider)
            return viewModel
        case .login:
            let viewModel = LoginViewModel(provider: provider)
            return viewModel
        }
    }
}
