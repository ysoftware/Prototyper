//
//  UIControlClosure.swift
//  MYCCore
//
//  Created by Ерохин Ярослав Игоревич on 14/10/2019.
//  Copyright © 2019 HCFB. All rights reserved.
//

import UIKit

private class ClosureSleeve {
    
    let closure: () -> ()
    
    init(attachTo object: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(object, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc func invoke() {
        closure()
    }
}

public extension UIControl {
    
    func addAction(_ action: @escaping () -> (),
                   for controlEvents: UIControl.Event = .primaryActionTriggered) {
        
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}
