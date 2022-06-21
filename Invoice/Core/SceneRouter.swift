//
//  SceneRouter.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Foundation

protocol SceneRouter {
    associatedtype SceneDestination
    func route<T>(to destination: T) where T == SceneDestination
}
