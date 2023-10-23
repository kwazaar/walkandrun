//
//  CustomTableViewCell.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 20.10.2023.
//

import UIKit
import MapKit

class CustomTableViewCell: UITableViewCell, MKMapViewDelegate {

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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }

}
