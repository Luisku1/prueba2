//
//  CeldaNoticiaTableViewCell.swift
//  YourScheduleFit
//
//  Created by UNAM FCA 24 on 19/05/22.
//

import UIKit

class CeldaNoticiaTableViewCell: UITableViewCell {

    @IBOutlet weak var tituloNoticiaLabel: UILabel!
    
    @IBOutlet weak var descripcionNoticiaLabel: UILabel!
    
    @IBOutlet weak var imagenNoticiaIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
