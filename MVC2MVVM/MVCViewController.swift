//
//  MVCViewController.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/14.
//

import UIKit

class MVCViewController: UIViewController {
    
    private var list: [DataModel] = []
    
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
        fetchData()
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
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard list.indices.contains(indexPath.row) else {
            fatalError("List is out of range on \(indexPath.row).")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.description(), for: indexPath) as! Cell
        
        let dataModel = list[indexPath.row]
        cell.configureCell(dataModel)
        
        if let imageUrl = dataModel.imageUrl {
            DispatchQueue.global().async {
                APIEngine.shared.fetchImg(urlString: imageUrl, defaultImg: nil) { img in
                    guard let url = cell.imgUrl, url == imageUrl else { return }
                    DispatchQueue.main.async {
                        cell.imageView?.image = img
                    }
                }
            }
        }
        return cell
    }
    
}


extension MVCViewController {
    
    private func didSelectedCell() {}
    
    private func fetchData() {
        APIEngine.shared.fetchFoo(req: Request<[DataModel]>()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.list = result.value ?? []
                self.tableView.reloadData()
            case .failure(let error):
                // do something
                print(error)
            }
        }
    }
}
