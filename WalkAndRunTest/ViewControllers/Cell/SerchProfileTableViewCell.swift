//
//  SerchProfileTableViewCell.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 18.11.2023.
//

import UIKit

class SerchProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
