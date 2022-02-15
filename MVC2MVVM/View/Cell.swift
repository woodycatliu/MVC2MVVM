//
//  Cell.swift
//  MVC2MVVM
//
//  Created by Woody on 2022/2/15.
//

import UIKit

class Cell: UITableViewCell {
    var itemLabel: UILabel?
    var contentLabel: UILabel?
    var itemImageView: UIImageView?
    var priceLabel: UILabel?
    var timestampLabel: UILabel?
    var imgUrl: String?
}

extension Cell {
    func configureCell(_ dataModel: DataModel) {
        itemLabel?.text = dataModel.item
        contentLabel?.text = dataModel.description
        priceLabel?.text = "\(dataModel.price ?? 0)"
        timestampLabel?.text = "\(dataModel.crateOn ?? 0)"
        imgUrl = dataModel.imageUrl
    }
}
