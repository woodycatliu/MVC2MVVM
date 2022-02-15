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
    
    let viewModel: CellViewModel = CellViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewModel.configureImageView = {
            [weak self] img in
            DispatchQueue.main.async {
                self?.imageView?.image = img
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel.imageUrlString = nil
        itemImageView?.image = nil
    }
    
}

extension Cell {
    func configureCell(_ dataModel: DataModel) {
        itemLabel?.text = dataModel.item
        contentLabel?.text = dataModel.description
        priceLabel?.text = "\(dataModel.price ?? 0)"
        timestampLabel?.text = "\(dataModel.crateOn ?? 0)"
        viewModel.imageUrlString = dataModel.imageUrl
    }
}
