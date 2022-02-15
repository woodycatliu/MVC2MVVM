//
//  ViewModel.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/15.
//

import Foundation

class ViewModel {
    var list: [DataModel] = []
    
    private func fetchData() {
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
