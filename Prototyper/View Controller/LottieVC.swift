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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var sliderView: SliderView!
    @IBOutlet weak var progressView: ProgressView!
    
    // MARK: - Vars
    
    private var animationManager: [AnimationManager] = []
    private var filesPathsList: [(name: String, url: URL)] = []
    private var imageProvider = ImageProvider()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupAnimation(.named("a")!)
        setupActions()
    }
    
    // MARK: - Actions
    
    @IBAction func removeAll(_ sender: Any) {
        FileService.removeAll()
        tableView.isHidden = true
    }
    
    @IBAction func loadAnimation(_ sender: Any) {
        tableView.isHidden = false
        filesPathsList = FileService.getList()
        tableView.reloadData()
    }
    
    @IBAction func importFile(_ sender: Any) {
        let types = ["public.json", "com.pkware.zip-archive"]
        let picker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }
    
    // MARK: - Methods
    
    private func setupViews() {
        sliderView.sensitivity = 1.4
        animationView.imageProvider = imageProvider
    }
    
    private func setupAnimation(_ animation: Animation) {
        animationView.animation = animation
        sliderView.value = 0
        progressView.numberOfSections = 1
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
        loadAnimation(self)
    }
}

extension LottieVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return filesPathsList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = filesPathsList[indexPath.row].name
        return cell
    }
}

extension LottieVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let file = filesPathsList[indexPath.row]
        let url = file.url.appendingPathComponent("data.json")
        
        guard let animation = Animation.filepath(url.path) else { return }
        imageProvider.baseUrl = file.url
        
        setupAnimation(animation)
        tableView.isHidden = true
    }
}
