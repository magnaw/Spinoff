//
//  WatchMeetingTableViewCell.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 11/05/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit

class WatchMeetingTableViewCell: UITableViewCell {
    @IBOutlet weak var meetingTitle: UILabel!
    @IBOutlet weak var meetingLocation: UILabel!
    @IBOutlet weak var meetingID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(meeting : Meeting) {
        meetingTitle.text = meeting.meetingTitle
        meetingID.text = "\(STATISTICS_TITLE_MEETING_ID): \(String(meeting.meetingId))"
        meetingLocation.text = "\(STATISTICS_TITLE_LOCATION): \(String(meeting.meetingRoom))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
