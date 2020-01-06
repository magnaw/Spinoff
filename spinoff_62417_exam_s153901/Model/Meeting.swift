//
//  Answers.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 07/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import Foundation

class Meeting {
    
    private(set) var startDate : Date!
    private(set) var endDate : Date!
    private(set) var meetingTitle : String!
    private(set) var meetingRoom : String!
    private(set) var meetingId : String!
    private(set) var documentId : String!
    
    init() {
    }
    
    //This one is never gonna get used?
    init(startDate : Date, endDate : Date, meetingTitle : String, meetingRoom : String) {
        self.startDate = startDate
        self.endDate = endDate
        self.meetingTitle = meetingTitle
        self.meetingRoom = meetingRoom
    }
    
    init(startDate : Date, endDate : Date, meetingTitle : String, meetingRoom : String, meetingId : String, documentId : String) {
        self.startDate = startDate
        self.endDate = endDate
        self.meetingTitle = meetingTitle
        self.meetingRoom = meetingRoom
        self.meetingId = meetingId
        self.documentId = documentId
    }
    
}
