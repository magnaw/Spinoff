//
//  MeetingTableViewCell.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 10/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//


import UIKit

class MeetingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(meeting : Meeting) {
        titleLabel.text = meeting.meetingTitle
        idLabel.text = "\(STATISTICS_TITLE_MEETING_ID): \(String(meeting.meetingId))"
    }

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
