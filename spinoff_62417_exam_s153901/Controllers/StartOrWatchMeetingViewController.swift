//
//  StartOrWatchMeetingViewController.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 01/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit

class StartOrWatchMeetingViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var watchStatisticsButton: UIButton!
    @IBOutlet weak var createMeetingButton: UIButton!
    
    //Variables
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Layout
        layoutButton(button: watchStatisticsButton)
        layoutButton(button: createMeetingButton)
        
        //Tilbageknap
        let backImage = UIImage(named: IMAGE_BACKARROW)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popNavigation))
    }
    
    @objc func popNavigation() {
        self.navigationController?.popViewController(animated: true)
    }

    func layoutButton(button : UIButton) {
        button.layer.cornerRadius = LAYOUT_CORNERRADIUS
        button.layer.shadowColor = LAYOUT_SHADOWCOLOR
        button.layer.shadowOffset = LAYOUT_SHADOWOFFSET
        button.layer.shadowOpacity = LAYOUT_SHADOWOPACITY
        button.layer.shadowRadius = LAYOUT_SHADOWRADIUS
        button.layer.masksToBounds = LAYOUT_MASKSTOBOUNDS
    }
}
