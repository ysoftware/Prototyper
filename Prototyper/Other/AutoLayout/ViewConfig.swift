//
//  ViewConfig.swift
//  MYCCore
//
//  Created by Ерохин Ярослав Игоревич on 14/10/2019.
//  Copyright © 2019 HCFB. All rights reserved.
//

import UIKit
import appendAttributedString

public enum MakeView {
    
    public static func view(
        _ backgroundColor: UIColor? = .clear) -> UIView {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor.flatMap { view.backgroundColor = $0 }
        return view
    }
    
    public static func stack(
        _ spacing: CGFloat = 0,
        axis: NSLayoutConstraint.Axis = .vertical,
        align: UIStackView.Alignment = .fill,
        distrib: UIStackView.Distribution = .fill) -> UIStackView {
        
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = spacing
        view.distribution = distrib
        view.alignment = align
        view.axis = axis
        return view
    }
    
    public static func image(
        _ imageName: String? = nil,
        image: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
        
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = contentMode
        imageName.flatMap { view.image = UIImage(named: $0) }
        image.flatMap { view.image = $0 }
        return view
    }
    
    public static func label(
        _ color: UIColor? = .white,
        font: UIFont? = nil,
        align: NSTextAlignment = .left) -> UILabel {
        
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        font.flatMap { view.font = $0 }
        color.flatMap { view.textColor = $0 }
        view.numberOfLines = 0
        view.textAlignment = align
        return view
    }
    
    public static func plainButton(
        title: String? = nil,
        image: UIImage? = nil,
        font: UIFont? = nil,
        color: UIColor? = nil,
        highlightedColor: UIColor? = nil,
        action: @escaping ()->Void) -> UIButton {
        
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle(title, for: .normal)
        view.setImage(image, for: .normal)
        color.flatMap { view.setTitleColor($0, for: .normal) }
        highlightedColor.flatMap { view.setTitleColor($0, for: .highlighted) }
        view.titleLabel?.font = font
        view.addAction(action)
        return view
    }
    
    public static func imageButton(
        _ imageName: String,
        tint: UIColor? = nil,
        action: @escaping ()->Void) -> UIButton {
    
        let view = plainButton(image: UIImage(named: imageName), action: action)
        tint.flatMap { view.tintColor = $0 }
        view.contentMode = .scaleAspectFit
        return view
    }
    
    public static func textField(
        hint: String = "",
        textColor: UIColor? = nil!,
        hintColor: UIColor? = nil!,
        font: UIFont? = nil) -> UITextField {
        
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = font
        textColor.flatMap { view.textColor = $0 }
        view.attributedPlaceholder = NSMutableAttributedString()
            .append(hint, color: hintColor ?? UIColor.gray, font: font)
        return view
    }
}

public extension UIView {

    func withTranslatesAutoresizingMaskDisabled() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
