//
//  DI.swift
//  NftApp
//
//  Created by Yegor on 27.11.2021.
//

import Foundation

protocol DIContainerProtocol {
    
    func register<Component>(type: Component.Type, component: Any)
    
    func resolve<Component>(type: Component.Type) -> Component
    
    func remove<Component>(type: Component.Type)
    
}

final class DIContainer: DIContainerProtocol {
    
    static let shared = DIContainer()

    private init() {}

    var components: [String: Any] = [:]

    func register<Component>(type: Component.Type, component: Any) {
        components["\(type)"] = component
    }

    func resolve<Component>(type: Component.Type) -> Component {
        guard let component = components["\(type)"] as? Component else {
            fatalError("DI error cast from: \(Component.self)")
        }
        
        return component
    }
    
    func remove<Component>(type: Component.Type) {
        components.removeValue(forKey: "\(type)")
    }
    
}
