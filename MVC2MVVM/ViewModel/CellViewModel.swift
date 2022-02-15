//
//  CellViewModel.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/15.
//

import Foundation
import UIKit

class CellViewModel: ImageViewFetchViewModelProtocol {
    var imageUrlString: String? {
        didSet {
            guard let urlString = imageUrlString else { return }
            fetchImage(urlString)
        }
    }
    var configureImageView: ConfigureImageView?
   
    private func fetchImage(_ urlString: String) {
        fetchImage(urlString, defaultImg: UIImage(named: "Nothing"))
    }
}

