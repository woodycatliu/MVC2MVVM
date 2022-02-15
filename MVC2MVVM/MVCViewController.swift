//
//  MVCViewController.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/14.
//

import UIKit

class MVCViewController: UIViewController {
    
    private lazy var viewModel: ViewModel = {
        let vm = ViewModel()
        vm.delegate = self
        return vm
    }()
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(Cell.self, forCellReuseIdentifier: Cell.description())
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.fetchData()
    }

    private func configureUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MVCViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Sometimes we will do something in here
        didSelectedCell()
    }
    
}

extension MVCViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.description(), for: indexPath) as! Cell
        let dataModel = viewModel.dataModelFoRowAt(indexPath)
        cell.configureCell(dataModel)
        
        if let imageUrl = dataModel.imageUrl {
            APIEngine.shared.fetchImg(urlString: imageUrl, defaultImg: nil) { img in
                guard let url = cell.imgUrl, url == imageUrl else { return }
                DispatchQueue.main.async {
                    cell.imageView?.image = img
                }
            }
        }
        return cell
    }
    
}

extension MVCViewController {
    private func didSelectedCell() {}
}

// MARK: DataModelsUpdateProtocol
extension MVCViewController: ViewModelDelegateProtocol {
   
    func updatedDataModels() {
        tableView.reloadData()
    }
    
    func handleHandle(_ error: APIError) {
        // whatEver
    }
    
}


