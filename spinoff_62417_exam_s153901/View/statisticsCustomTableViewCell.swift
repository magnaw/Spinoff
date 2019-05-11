//
//  statisticsCustomTableViewCell.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 28/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit
import Cosmos
import Foundation

class statisticsCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var contentViewOutlet: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        starView.settings.updateOnTouch = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(title : String, rating : Double) {
        labelText.text = title
        var newRating = round(rating)
        if newRating < 1 {
            newRating = 1
        }
        starView.rating = newRating
        
    }
    
}
