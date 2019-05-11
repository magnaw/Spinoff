//
//  Answers.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 07/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import Foundation

class Answers {
    
    private(set) var answers : [Int]!
    private(set) var documentId : String!
    
    init(answers : [Int]) {
        self.answers = answers
    }
    
    init(answers : [Int], documentId : String) {
        self.answers = answers
        self.documentId = documentId
    }
    
}
