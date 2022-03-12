//
//  +UIView.swift
//  Project10
//
//  Created by Lucas Maniero on 28/02/22.
//

import UIKit

extension UIView {
    
    func fillSuperView(with margin: CGFloat = 0.0) {
        guard let superview = superview else {return}
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: margin),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: margin),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: margin),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: margin)
        ])
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
