//
//  TableViewCell.swift
//  YourScheduleFit
//
//  Created by UNAM FCA 24 on 07/04/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblNameFood: UILabel!
    
    @IBOutlet weak var lblFoodTime: UILabel!
    
    @IBOutlet weak var lblIcon: UILabel!
    
    @IBOutlet weak var lblCalories: UILabel!
    
    @IBOutlet weak var lblQuantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
