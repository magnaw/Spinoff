//
//  StartScreenViewController.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 25/03/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class StartScreenViewController: UIViewController {

    //OUTLETS
    @IBOutlet weak var CompanyIDTextField: UITextField!
    @IBOutlet weak var enteredIdButtonOutlet: UIButton!
    
    //VARIABLES
    private var companyCollectionRef: CollectionReference!
    private var companyInputAccepted : Bool = false
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Layout setup
        layoutTextfields(textfield: CompanyIDTextField)
        layoutButton(button: enteredIdButtonOutlet)
        
        

        // If company has been logged into before, automatically input the ID
        if let companyIDFromUserDefaults = defaults.string(forKey: COMPANY_ID_KEY) {
            CompanyIDTextField.text = companyIDFromUserDefaults
        }
        //Firebase reference
        companyCollectionRef = Firestore.firestore().collection(COMPANY_REF)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func registerCompany(_ sender: Any) {
        alertUserForInput()
    }
    
    @IBAction func enteredIDButton(_ sender: UIButton) {
        print("You pressed the enteredIDButton!")
        //Prevent doubletaps
        enteredIdButtonOutlet.isEnabled = false
        self.view.endEditing(true)


        //Set to lowercase to avoid confusion
        let userInputText : String = CompanyIDTextField.text!.lowercased()
        var inputAccepted : Bool = false

        companyCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("ERROR LOADING COMPANY ID's - \(error)")
            } else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    var title = data[COMPANY_TITLE] as? String
//                    let documentId = document.documentID

                    //Set to lowercase to avoid confusion
                    title = title?.lowercased()

                    if userInputText == title {
                        //Save input for other uses of the app
                        self.defaults.set(self.CompanyIDTextField.text!, forKey: COMPANY_ID_KEY)
                        inputAccepted = true
                        self.resetBorderColorTextField(textfield: self.CompanyIDTextField)
                        self.performSegue(withIdentifier: "goToChooseRole", sender: self)
                    } else {
                        self.enteredIdButtonOutlet.isEnabled = true
                    }
                }
                if !inputAccepted {
//                    self.messageToUser(title: ALERT_WRONG_COMPANY_MESSAGE, message: "")
                    self.CompanyIDTextField.shake()
                }
            }
        }
    }
    
    //Prompter user for input til registrering af ny virksomhed
    func alertUserForInput() {
        let alert = UIAlertController(title: REGISTER_COMPANY_ALERT_TITLE, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ALERT_ACTION_TITLE_CANCEL, style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = ALERT_TITLE_PLACEHOLDER
        })
        alert.addAction(UIAlertAction(title: ALERT_ACTION_TITLE_OK, style: .default, handler: { action in
            guard let newCompany = alert.textFields?.first?.text, !newCompany.isEmpty else {
                self.messageToUser(title: REGISTER_COMPANY_ALERT_TITLE, message: REGISTER_COMPANY_DENIED)
                return
            }
            if let newCompany = alert.textFields?.first?.text {
                let data : [String : Any] = [
                    COMPANY_TITLE : newCompany.lowercased()
                ]
                self.companyCollectionRef.document(newCompany.lowercased()).setData(data) { err in
                    if let err = err {
                        debugPrint("Error creating company : \(err)")
                        self.messageToUser(title: REGISTER_COMPANY_ALERT_TITLE, message: REGISTER_COMPANY_DENIED)
                    } else {
//                        self.inputAcceptedorDenied(acceptedOrNot: true)
                        self.messageToUser(title: REGISTER_COMPANY_ALERT_TITLE, message: REGISTER_COMPANY_ACCEPTED)
                    }
                }
            }
        }))
        self.present(alert, animated: true)
    }
    
    func messageToUser(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ALERT_ACTION_TITLE_OK, style: .default, handler: nil))
        self.present(alert, animated: true)
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
