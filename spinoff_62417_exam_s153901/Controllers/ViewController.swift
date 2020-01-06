//
//  ViewController.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 25/03/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Tilbageknap
        let backImage = UIImage(named: IMAGE_BACKARROW)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popNavigation))
    }
    
    @objc func popNavigation() {
        self.navigationController?.popViewController(animated: true)
    }
    


}
