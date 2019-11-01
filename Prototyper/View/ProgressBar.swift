//
//  ProgressBar.swift
//  Prototyper
//
//  Created by Ерохин Ярослав Игоревич on 29/09/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

@IBDesignable
public class ProgressView: UIStackView {
    
    // MARK: - Variables
    
    @IBInspectable
    public var highlightedColor: UIColor = .white {
        didSet { reloadSections() }
    }
    
    @IBInspectable
    public var sectionColor: UIColor = .gray {
        didSet { reloadSections() }
    }
    
    @IBInspectable
    public var numberOfSections: Int = 1 {
        didSet { reloadSections() }
    }
    
    // MARK: - Methods
    
    public func setProgress(_ progress: Double,
                            for section: Int,
                            animationDuration: Double = 0) {
        
        UIView.animate(withDuration: animationDuration) {
            (self.arrangedSubviews[section] as! ProgressBar).progress = progress
        }
    }
    
    public override func addArrangedSubview(_ view: UIView) {
        if view is ProgressBar {
            super.addArrangedSubview(view)
        }
    }
    
    // MARK: - Private
    
    private func reloadSections() {
        distribution = .fillEqually
        
        subviews.forEach { subview in
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for _ in 0..<numberOfSections {
            let bar = ProgressBar()
            bar.backgroundColor = sectionColor
            bar.foregroundColor = highlightedColor
            addArrangedSubview(bar)
        }
    }
}

// MARK: - Progress Subview

fileprivate class ProgressBar: UIView {
    
    public var progress: Double = 0.0 {
        didSet { reloadViews() }
    }
    
    public var foregroundColor: UIColor = .white {
        didSet { progressView.backgroundColor = foregroundColor }
    }
    
    // MARK: - Other
    
    private let progressView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadViews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func reloadViews() {
        let size = CGSize(width: bounds.width * CGFloat(progress),
                          height: bounds.height)
        progressView.frame = CGRect(origin: .zero, size: size)
    }
    
    private func setup() {
        clipsToBounds = true
        backgroundColor = .gray
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressView)
        layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}
