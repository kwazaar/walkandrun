//
//  NewsCollectionViewCell.swift
//  WalkAndRunTest
//
//  Created by MaxOS on 08.11.2023.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var showMoreButton: UIButton!
    
    @IBOutlet weak var heightText: NSLayoutConstraint!
    
    weak var delegate: CollectionViewCellDelegateButton?
    
    
    
    @IBAction func showMoreButtonPress(_ sender: UIButton) {
        delegate?.showMoreButtonPressed(in: self)
    }
    
    func heightForText() -> CGFloat {
            let labelWidth = postText.bounds.width
            let maxSize = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)
            let textSize = postText.sizeThatFits(maxSize)
            return textSize.height
        }
    
}

protocol CollectionViewCellDelegateButton: AnyObject {
    
    func showMoreButtonPressed(in cell: NewsCollectionViewCell)
    
}
