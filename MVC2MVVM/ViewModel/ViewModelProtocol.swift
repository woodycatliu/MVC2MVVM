//
//  ViewModelProtocol.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/15.
//

import Foundation

protocol TableViewModelProtocol {
    associatedtype DataModelForCell
    var numbersOfSection: Int { get }
    func numberOfRowsInSection(_ section: Int)-> Int
    func dataModelFoRowAt(_ indexPath: IndexPath)-> DataModelForCell
}
