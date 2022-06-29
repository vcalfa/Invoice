//
//  UIView+Layout.swift
//  Invoice
//
//  Created by Vladimir Calfa on 29/06/2022.
//

import Foundation
import UIKit

extension UIView {
    
    func pinToMargins(_ view: UIView, insets: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right),
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -insets.left),
            layoutMarginsGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
        ])
    }
    
    func pinSubview(_ view: UIView, insets: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
    }
}
