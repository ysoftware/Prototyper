//
//  AutoLayoutUtils.swift
//  MYCFoundation
//
//  Created by Ерохин Ярослав Игоревич on 05/09/2019.
//  Copyright © 2019 HCFB. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {
    
    func prioritizing(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
    func activated() -> NSLayoutConstraint {
        isActive = true
        return self
    }
}

public extension Dictionary where Key == UIView.Anchor, Value == NSLayoutConstraint {
    
    func activateAll() {
        NSLayoutConstraint.activate(values.map { $0 })
    }
}

public extension Array where Element == NSLayoutConstraint {
    
    func activateAll() {
        NSLayoutConstraint.activate(self)
    }
}

public extension Array where Element == UIView.Anchor {
    
    static let allButTrailing: [Element] = [.top, .bottom, .leading]
    static let allButLeading: [Element] = [.top, .trailing, .bottom]
    static let allButBottom: [Element] = [.top, .trailing, .leading]
    static let allButTop: [Element] = [.trailing, .bottom, .leading]
    static let horizontal: [Element] = [.trailing, .leading]
    static let vertical: [Element] = [.top, .bottom]
    static let size: [Element] = [.width, .height]
    static let center: [Element] = [.centerX, .centerY]
    
    static let verticalScrollContent: [Element] = [
        .top, .trailing, .bottom, .leading, .centerX
    ]
    
    static let horizontalScrollContent: [Element] = [
        .top, .trailing, .bottom, .leading, .centerY
    ]
}
