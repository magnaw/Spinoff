//
//  MyCustomCreateQuestionCell.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 16/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit

class MyCustomCreateQuestionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userWillInputField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.userWillInputField.isUserInteractionEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.userWillInputField.isUserInteractionEnabled = selected
        if selected {
            self.userWillInputField.becomeFirstResponder()
        }

        // Configure the view for the selected state
    }
    
    func configureCell(title : String, usersInput : String) {
        titleLabel.text = title
        userWillInputField.text = usersInput
    }
    
}
