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
    @IBOutlet weak var progressView: ProgressView!
    
    // MARK: - Vars
    
    private var animationManager: [AnimationManager] = []
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
//        setupAnimation(.named("a")!)
        setupActions()
    }
    
    // MARK: - Actions
    
    @IBAction func load(_ sender: Any) {
        FileService.getList()
        
        let types = ["public.json", "com.pkware.zip-archive"]
        let picker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }
    
    // MARK: - Methods
    
    private func setupViews() {
        sliderView.sensitivity = 1.4
    }
    
    private func setupAnimation(_ animation: Animation) {
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
        progressView.setProgress(Double(value), for: 0)
    }
}

extension LottieVC: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentsAt urls: [URL]) {
        
        _ = urls.first.flatMap { FileService.importFile($0) }
    }
}
