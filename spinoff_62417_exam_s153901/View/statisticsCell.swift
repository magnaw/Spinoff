//
//  statisticsCell.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 28/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit

class statisticsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(title : String, rating : Double) {
        titleLabel.text = title
        ratingLabel.text = String(rating)
    }
    
    

}
