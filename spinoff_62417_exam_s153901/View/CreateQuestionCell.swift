//
//  CreateQuestionCell.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 15/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

// NOT BEING USED CURRENTLY


import UIKit

class CreateQuestionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userWillInputLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(title : String, usersInput : String) {
        titleLabel.text = title
        userWillInputLabel.text = usersInput
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


