//
//  MeetingOrganiserViewController.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 10/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit
import Firebase

class MeetingOrganiserViewController: UIViewController, UITextFieldDelegate {
    
    //OUTLETS
    @IBOutlet weak var meetingTitleText: UITextField!
    @IBOutlet weak var meetingLocationText: UITextField!
    @IBOutlet weak var meetingStartText: UITextField!
    @IBOutlet weak var meetingEndText: UITextField!
    @IBOutlet weak var goToAgendaScreenOutlet: UIButton!
    
    
    //VARIABLES
    private var newMeeting : Meeting!
    private var startTime : Date = Date()
    private var endTime : Date = Date()
    private var topic : String = ""
    private var location : String = ""
    
    private var toolBar = UIToolbar()
    private var dateFormatter = DateFormatter()
    
    //FIREBASE AND USERDEFAULTS
    private var meetingsCollectionRef : CollectionReference!
    let defaults = UserDefaults.standard
    private var companyIdString : String = ""
    
    //Test
    private var myDatePicker = UIDatePicker()
    private var selectedTextField = UITextField()
    private var actualStartTime : Date = Date()
    private var actualEndTime : Date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Layout setup
        layoutTextfields(textfield: meetingTitleText)
        layoutTextfields(textfield: meetingLocationText)
        layoutTextfields(textfield: meetingStartText)
        layoutTextfields(textfield: meetingEndText)
        layoutButton(button: goToAgendaScreenOutlet)
        
        //Get the company ID from user defaults (Was stored on login, so should always work)
        if let companyIDFromUserDefaults = defaults.string(forKey: COMPANY_ID_KEY) {
            companyIdString = companyIDFromUserDefaults.lowercased()
        }
        meetingsCollectionRef = Firestore.firestore().collection(COMPANY_REF).document(companyIdString).collection(MEETING_REF)

        showDatePicker(textField: meetingStartText)
        showDatePicker(textField: meetingEndText)
        
        let backImage = UIImage(named: IMAGE_BACKARROW)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popNavigation))
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
    }
    
    
    @objc func keyboardWillShow(Notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 30.0
        }
    }
    
    @objc func keyboardWillHide(Notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func popNavigation() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }

    func showDatePicker(textField : UITextField){
        myDatePicker.datePickerMode = .dateAndTime
        myDatePicker.minuteInterval = 15
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: CHOOSE_DATE, style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: CANCEL_DATE, style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        textField.inputAccessoryView = toolbar
        textField.inputView = myDatePicker
        
    }
    
    @objc func doneDatePicker(){
        
        let selectedDate : Date = myDatePicker.date
        
        //Convert to string and make readable by user
        let dateAndTime : String = "\(selectedDate)"
        let cutDateAndTime = dateAndTime.dropLast(9)
        
        //Check current textfield
        let current = view.getSelectedTextField()
        
        //Save the original Date object for later use
        if current == meetingStartText {
            actualStartTime = selectedDate
        } else {
            actualEndTime = selectedDate
        }
        
        //Update textfield
        current?.text = "\(cutDateAndTime)"
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    @IBAction func goToAgendaScreen(_ sender: Any) {
        
        //Make sure all textfields have input
        guard let titleText = meetingTitleText.text, !titleText.isEmpty else {
            self.meetingTitleText.shake()
            return
        }
        guard let locationText = meetingLocationText.text, !locationText.isEmpty else {
            self.meetingLocationText.shake()
            return
        }
        guard let startText = meetingStartText.text, !startText.isEmpty else {
            self.meetingStartText.shake()
            return
        }
        guard let endText = meetingEndText.text, !endText.isEmpty else {
            self.meetingEndText.shake()
            return
        }
        
        //Prepare data for upload
        let meetingId = randomString(length: 4)
        let data : [String : Any] = [
        MEETING_TOPIC: titleText,
        MEETING_LOCATION: locationText,
        MEETING_START_TIME: actualStartTime,
        MEETING_END_TIME: actualEndTime,
        MEETING_ID: meetingId
            ]
        
        //Upload data and go to next screen
        meetingsCollectionRef.document(meetingId).setData(data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
            else {
                //Save the meeting id for later reference.
                self.defaults.set(meetingId, forKey: CREATE_MEETING_ID_KEY)
                self.resetBorderColorTextField(textfield: self.meetingTitleText)
                self.resetBorderColorTextField(textfield: self.meetingLocationText)
                self.resetBorderColorTextField(textfield: self.meetingStartText)
                self.resetBorderColorTextField(textfield: self.meetingEndText)
                self.performSegue(withIdentifier: "goToAgendaScreen", sender: self)
            }
        }

    }
    
    //Generate a random meeting ID. I know that its possible for dublicates, but as theres 14 million combinations (With a 4 character id) in this function, I'm going to put my faith in that not happening.
    func randomString(length: Int) -> String {
        let letters = RANDOM_LETTERS_FOR_MEETING_ID
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    //Alert to show when user has not filled in all textfields
    func alertUserInputMissing() {
        let alert = UIAlertController(title: ALERT_INPUT_MISSING_ERROR_TITLE, message: ALERT_INPUT_MISSING_ERROR_MESSAGE, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(ALERT_ACTION_TITLE_OK, comment: ALERT_ACTION_COMMENT), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
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

//Should change Date to be local, will check later
//extension Date {
//    var localizedDescription: String {
//        return description(with: .current)
//    }
//}

//Used to get the active textfield
extension UIView {
    func getSelectedTextField() -> UITextField? {
        let totalTextFields = getTextFieldsInView(view: self)
        for textField in totalTextFields{
            if textField.isFirstResponder{
                return textField
            }
        }
        return nil
    }
    func getTextFieldsInView(view: UIView) -> [UITextField] {
        var totalTextFields = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                totalTextFields += [textField]
            } else {
                totalTextFields += getTextFieldsInView(view: subview)
            }
        }
        return totalTextFields
    }
}
