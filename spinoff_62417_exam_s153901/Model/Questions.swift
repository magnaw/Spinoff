//
//  Questions.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 08/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import Foundation

class Questions {
    
    private(set) var questions : [String]!
    private(set) var documentId : String!
    
    init(questions : [String]) {
        self.questions = questions
    }
    
    init(questions : [String], documentId : String) {
        self.questions = questions
        self.documentId = documentId
    }
}
