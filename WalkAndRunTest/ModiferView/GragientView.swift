//
//  GragientView.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 13.09.2023.
//

import Foundation
import UIKit


class GragientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupLayer() {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [UIColor(named: "bgColor1")!.cgColor, UIColor(named: "bgColor2")!.cgColor ]
    }
    
}
