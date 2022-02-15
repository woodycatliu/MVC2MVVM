//
//  ViewModel.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/15.
//

import Foundation

class ViewModel {
    private var list: [DataModel] = []
        
    func fetchData() {
        APIEngine.shared.fetchFoo(req: Request<[DataModel]>()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.list = result.value ?? []
            case .failure(let error):
                // do something
                print(error)
            }
        }
    }
}

// MARK: TableViewModelProtocol
extension ViewModel: TableViewModelProtocol {
    
    typealias DataModelForCell = DataModel

    var numbersOfSection: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return list.count
    }
    
    func dataModelFoRowAt(_ indexPath: IndexPath) -> DataModel {
        guard list.indices.contains(indexPath.row) else {
            fatalError("\(#function): \(indexPath) is out of Range")
        }
        return list[indexPath.row]
    }
}
