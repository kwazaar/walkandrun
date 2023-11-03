//
//  HourTableViewCell.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 03.11.2023.
//

import UIKit

class HourTableViewCell: UITableViewCell {

    @IBOutlet weak var hourWeather: UILabel!
    @IBOutlet weak var tempWeather: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
