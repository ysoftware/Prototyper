//
//  PinConstraints.swift
//  MYCFoundation
//
//  Created by Ерохин Ярослав Игоревич on 04/09/2019.
//  Copyright © 2019 HCFB. All rights reserved.
//

import UIKit

public extension UIView {
    
    enum Anchor: CaseIterable {
        
        case top, trailing, bottom, leading, centerX, centerY, width, height
    }
    
    // MARK: - Main Method
    
    /// Последовательность `view` важна при constant != 0.
    /// Стоит следовать подходу `subview.pin(to: superview)`.
    @discardableResult
    func pin(to view: UIView,
             constant: CGFloat = 0,
             anchors: [Anchor] = [.top, .trailing, .bottom, .leading],
             activate:Bool = true)
        -> [Anchor:NSLayoutConstraint] {
            
            var constraints: [Anchor:NSLayoutConstraint] = [:]
            
            if anchors.contains(.top) {
                constraints[.top] = topAnchor.constraint(
                    equalTo: view.topAnchor, constant: constant)
            }
            if anchors.contains(.trailing) {
                constraints[.trailing] = view.trailingAnchor.constraint(
                    equalTo: trailingAnchor, constant: constant)
            }
            if anchors.contains(.bottom) {
                constraints[.bottom] = view.bottomAnchor.constraint(
                    equalTo: bottomAnchor, constant: constant)
            }
            if anchors.contains(.leading) {
                constraints[.leading] = leadingAnchor.constraint(
                    equalTo: view.leadingAnchor, constant: constant)
            }
            if anchors.contains(.centerX) {
                constraints[.centerX] = centerXAnchor.constraint(
                    equalTo: view.centerXAnchor, constant: constant)
            }
            if anchors.contains(.centerY) {
                constraints[.centerY] = centerYAnchor.constraint(
                    equalTo: view.centerYAnchor, constant: constant)
            }
            if anchors.contains(.width) {
                constraints[.width] = widthAnchor.constraint(
                    equalTo: view.widthAnchor, constant: constant)
            }
            if anchors.contains(.height) {
                constraints[.height] = heightAnchor.constraint(
                    equalTo: view.heightAnchor, constant: constant)
            }
            
            if activate {
                constraints.activateAll()
            }
            
            return constraints
    }
}
