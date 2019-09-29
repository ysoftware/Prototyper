//
//  ViewController.swift
//  Prototyper
//
//  Created by Ерохин Ярослав Игоревич on 29/9/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit
import Lottie

class LottieVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var sliderView: SliderView!
    
    // MARK: - Vars
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupAnimation()
        setupActions()
    }
    
    // MARK: - Actions
    

    // MARK: - Methods
    
    private func setupViews() {
        sliderView.sensitivity = 1.4
    }
    
    private func setupAnimation() {
        let animation = Animation.named("a")!
        animationView.animation = animation
        sliderView.value = 0
    }
    
    private func setupActions() {
        sliderView.delegate = self
    }
    
    // MARK: - Subviews
    
    private lazy var animationView: AnimationView = {
        let view = AnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        view.pin(to: container)
        return view
    }()
}

extension LottieVC: SliderViewDelegate {
        
    func sliderView(_ sliderView: SliderView, newValue value: Float) {
        animationView.currentProgress = AnimationProgressTime(value)
    }
}
