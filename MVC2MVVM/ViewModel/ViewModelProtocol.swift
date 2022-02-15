//
//  ViewModelProtocol.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/15.
//

import Foundation
import UIKit

protocol TableViewModelProtocol {
    associatedtype DataModelForCell
    var numbersOfSection: Int { get }
    func numberOfRowsInSection(_ section: Int)-> Int
    func dataModelFoRowAt(_ indexPath: IndexPath)-> DataModelForCell
}

protocol ImageViewFetchViewModelProtocol: AnyObject {
    typealias ConfigureImageView = (UIImage?)->()
    var imageUrlString: String? { get set }
    var configureImageView: ConfigureImageView? { get set }
    func fetchImage(_ urlString: String?, defaultImg: UIImage?)
}

extension ImageViewFetchViewModelProtocol {
    
    func fetchImage(_ urlString: String?, defaultImg: UIImage?) {
        guard let urlString = urlString else {
            return
        }
        APIEngine.shared.fetchImg(urlString: urlString, defaultImg: defaultImg) {
            [weak self] img in
            guard self?.imageUrlString == urlString else { return }
            self?.configureImageView?(img)
        }
    }
}
