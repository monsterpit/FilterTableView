//
//  TableViewCell.swift
//  FilterTableView
//
//  Created by MB on 8/13/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var textLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /*!
     * @discussion This function is to configure your cell using viewmodel
     * @param itemViewModel
     * @return void
     */
    func configure(withItemViewModel itemViewModel : ItemViewModel) -> (){
        idLabel.text = itemViewModel.id
        textLbl.text = itemViewModel.textValue
    }
    
}
