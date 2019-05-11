//
//  JoinMeetingViewController.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 28/03/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit
import Firebase

class JoinMeetingViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var meetingIdTextField: UITextField!
    @IBOutlet weak var continueToMeetingButtonOutlet: UIButton!
    
    //Variables
    let defaults = UserDefaults.standard
    private var meetingCollectionRef: CollectionReference!
    private var companyInputAccepted : Bool = false
    private var companyIdString : String = ""
    private var meetingIdString : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Layout setup
        layoutTextfields(textfield: meetingIdTextField)
        layoutButton(button: continueToMeetingButtonOutlet)
        
        //Get the company ID from user defaults (Was stored on login, so should always work)
        if let companyIDFromUserDefaults = defaults.string(forKey: COMPANY_ID_KEY) {
            companyIdString = companyIDFromUserDefaults.lowercased()
        }
        if let meetingIDFromUserDefaults = defaults.string(forKey: CREATE_MEETING_ID_KEY) {
            meetingIdString = meetingIDFromUserDefaults
        }

        
        //Firebase reference
        meetingCollectionRef = Firestore.firestore().collection(COMPANY_REF).document(companyIdString).collection(MEETING_REF)

        let backImage = UIImage(named: IMAGE_BACKARROW)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popNavigation))
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(Notification: NSNotification) {
        guard let userInfo = Notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 150.0
        }
    }
    
    @objc func keyboardWillHide(Notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.continueToMeetingButtonOutlet.isEnabled = true
    }
    
    @objc func popNavigation() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Alert to show when user has not filled in all textfields
    func alertUserWrongMeetingId() {
        let alert = UIAlertController(title: ALERT_INPUT_MISSING_ERROR_TITLE, message: ALERT_WRONG_MEETING_ID_MESSAGE, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(ALERT_ACTION_TITLE_OK, comment: ALERT_ACTION_COMMENT), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func continueToMeetingButton(_ sender: Any) {
        //Set to lowercase to avoid confusion
        let userInputText : String = meetingIdTextField.text!
        companyInputAccepted = false
        //Prevent doubletaps
        continueToMeetingButtonOutlet.isEnabled = false
        
        self.view.endEditing(true)
        
        
        
        
        meetingCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("ERROR LOADING COMPANY ID's - \(error)")
            } else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    let meetingId = data[MEETING_ID] as? String
                    if userInputText == meetingId {
                        //Accept the id for next step.
                        self.companyInputAccepted = true
                        //Save the meeting id for later reference.
                        self.defaults.set(meetingId, forKey: JOIN_MEETING_ID_KEY)
                    }
                        
                }
                if self.companyInputAccepted {
                    print("Det virkede, vi sender videre")
                    self.resetBorderColorTextField(textfield: self.meetingIdTextField)
                    self.performSegue(withIdentifier: "goToStartFeedbackScreen", sender: self)
                } else {
                    print("Det virkede ikke, vi laver alert")
                    self.continueToMeetingButtonOutlet.isEnabled = true
//                    self.alertUserWrongMeetingId()
                    self.meetingIdTextField.shake()
                }
            }
        }
    }
    
    func layoutTextfields(textfield : UITextField) {
        textfield.layer.cornerRadius = LAYOUT_CORNERRADIUS
        textfield.layer.borderWidth = LAYOUT_BORDERWIDTH
        textfield.layer.borderColor = LAYOUT_BORDERCOLOR
        textfield.layer.shadowColor = LAYOUT_SHADOWCOLOR
        textfield.layer.shadowOffset = LAYOUT_SHADOWOFFSET
        textfield.layer.shadowOpacity = LAYOUT_SHADOWOPACITY
        textfield.layer.shadowRadius = LAYOUT_SHADOWRADIUS
        textfield.layer.masksToBounds = LAYOUT_MASKSTOBOUNDS
    }
    
    func resetBorderColorTextField(textfield : UITextField) {
        textfield.layer.borderColor = LAYOUT_BORDERCOLOR
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
