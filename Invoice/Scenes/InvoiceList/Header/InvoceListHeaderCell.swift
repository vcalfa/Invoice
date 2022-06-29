//
//  InvoceListHeaderCell.swift
//  Invoice
//
//  Created by Vladimir Calfa on 29/06/2022.
//

import Foundation
import UIKit

class InvoceListHeaderCell: UICollectionReusableView {
    
    var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
    }
    
    func setupUI() {
        backgroundColor = .lightGray
    }
    
    func setupLayout() {
        pinToMargins(title, insets: .init(top: 4, left: 0,
                                          bottom: 4, right: 0))
    }
}

