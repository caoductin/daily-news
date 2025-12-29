//
//  Coordinator.swift
//  AppBlogDATN
//
//  Created by TEAMS on 12/29/25.
//

import Foundation
import SwiftUI

protocol Coordinator: ObservableObject {
    associatedtype ScreenType: Hashable
    var path: NavigationPath { get set }
    
    func push(_ screen: ScreenType)
    func pop()
    func popToRoot()
}

extension Coordinator {
    func push(_ screen: ScreenType) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
