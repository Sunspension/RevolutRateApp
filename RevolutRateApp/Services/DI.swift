//
//  DI.swift
//  RevolutRateApp
//
//  Created by Vladimir Kokhanevich on 12/07/2018.
//  Copyright © 2018 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

enum ControllerType: String {
    
    case main = "Main"
}

struct DC {
    
    static let shared = DC()
    
    private let container = Container()
    
    private let storyBoard: SwinjectStoryboard
    
    private init() {
        
        storyBoard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        
        container.register(ApiProtocol.self, factory: { _ in API() })
        
        container.storyboardInitCompleted(TableViewController.self) { resolver, controller in
            
            let api = resolver.resolve(ApiProtocol.self)!
            controller.viewModel = MainViewModel(api: api)
        }
    }
    
    func controller(_ type: ControllerType) -> UIViewController {
        
        switch type {
            
        case .main:
            
            return storyBoard.instantiateViewController(withIdentifier: type.rawValue)
        }
    }
}
