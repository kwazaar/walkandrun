//
//  CustomTableViewCell.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 20.10.2023.
//

import UIKit
import MapKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var distanceLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
