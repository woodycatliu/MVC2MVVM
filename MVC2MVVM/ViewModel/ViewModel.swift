//
//  ViewModel.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/15.
//

import Foundation


protocol DataModelsUpdateProtocol: AnyObject {
    func updatedDataModels()
    func updateDataModel(_ index: Int)
}

extension DataModelsUpdateProtocol {
    func updateDataModel(_ index: Int) {}
}

protocol APIErrorHandleProtocol: AnyObject {
    func handleHandle(_ error: APIError)
}

typealias ViewModelDelegateProtocol = DataModelsUpdateProtocol&APIErrorHandleProtocol

class ViewModel {
    
    weak var delegate: ViewModelDelegateProtocol?

    private var list: [DataModel] = [] {
        didSet {
            delegate?.updatedDataModels()
        }
    }
    
    func fetchData() {
        APIEngine.shared.fetchFoo(req: Request<[DataModel]>()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.list = result.value ?? []
            case .failure(let error):
                // do something
                print(error)
                self.delegate?.handleHandle(error)
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
