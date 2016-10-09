//
//  GroceryTableViewCell.swift
//  ShoppingList
//
//  Created by Uldis Zingis on 07/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit

class GroceryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checboxButton: UIButton!
    
    weak var delegate: GroceryTableViewCellDelegate?
    
    func updateWithGrocery(grocery: Grocery) {
        nameLabel.text = grocery.name
        let image = grocery.isComplete ? #imageLiteral(resourceName: "checked") : #imageLiteral(resourceName: "notChecked")
        checboxButton.setImage(image, for: .normal)
    }

    @IBAction func checkboxTapped(_ sender: AnyObject) {
        if let delegate = delegate {
            delegate.cellCheckboxButtonTapped(sender: self)
        }
    }
}

protocol GroceryTableViewCellDelegate: class {
    func cellCheckboxButtonTapped(sender: GroceryTableViewCell)
}
