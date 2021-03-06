//
//  ChoseRoleViewController.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 28/03/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit

class ChooseRoleViewController: UIViewController {
    @IBOutlet weak var meetingParticipantButton: UIButton!
    @IBOutlet weak var meetingLeaderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Layout setup
        layoutButton(button: meetingParticipantButton)
        layoutButton(button: meetingLeaderButton)

        //Tilbageknap
        let backImage = UIImage(named: IMAGE_BACKARROW)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popNavigation))
        
    }
    
    @objc func popNavigation() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
