//
//  CollectionViewCell.swift
//  Awards
//
//  Created by Mihnea on 6/27/22.
//

import UIKit

class AwardCell: UICollectionViewCell {
    @IBOutlet weak var awardView : UIImageView!
    @IBOutlet weak var awardCount : UILabel!
    @IBOutlet weak var removeButton : UIButton!
    
    var buttonAction: ((Any) -> Void)?
    
    @IBAction func didTapDelete(_ sender: Any) {
        self.buttonAction?(sender)
    }
}
