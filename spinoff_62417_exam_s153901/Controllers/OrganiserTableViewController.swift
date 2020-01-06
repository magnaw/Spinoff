//
//  OrganiserTableViewController.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 08/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit
import Firebase

class OrganiserTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createMeetingButtonOutlet: UIButton!
    @IBOutlet weak var topViewBottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var createMeetingButtonConstraint: NSLayoutConstraint!
    
    //Variables
    private var questionsArray : [String] = []
    private var questions : Questions!
    private var newQuestionToAdd = ""
    private var currentlySelectedTextfield : Int = 0
    private var originalConstantHeight : CGFloat = 0.0
    
    //FIREBASE AND USERDEFAULTS
    private var agendaCollectionsRef : CollectionReference!
    let defaults = UserDefaults.standard
    private var companyIdString : String = ""
    private var meetingIdString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        
        originalConstantHeight = topViewBottomConstaint.constant
        
        //Layout
        layoutButton(button: createMeetingButtonOutlet)
        
        //Register my custom table cell
        tableView.register(UINib(nibName: "YoshikoCreateMeetingTableViewCell", bundle: nil), forCellReuseIdentifier: "yoshikoCreateMeetingCell")
        
        //Get the company ID from user defaults (Was stored on login, so should always work)
        if let companyIDFromUserDefaults = defaults.string(forKey: COMPANY_ID_KEY) {companyIdString = companyIDFromUserDefaults.lowercased()}
        //Get the meeting ID from user defaults
        if let meetingIDFromUserDefaults = defaults.string(forKey: CREATE_MEETING_ID_KEY) {meetingIdString = meetingIDFromUserDefaults}
        
        //Firebase reference
        agendaCollectionsRef = Firestore.firestore().collection(COMPANY_REF).document(companyIdString).collection(MEETING_REF)
        
        //Tilbageknap
        let backImage = UIImage(named: IMAGE_BACKARROW)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popNavigation))
        
        //Keyboard will show
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(Notification: NSNotification) {
        if let keyboardFrame: NSValue = Notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.topViewBottomConstaint?.constant = originalConstantHeight - keyboardHeight
        }
    }

    @objc func keyboardWillHide(Notification: NSNotification) {
        self.topViewBottomConstaint?.constant = originalConstantHeight
    }
    

    @objc func popNavigation() {
        agendaCollectionsRef.document(meetingIdString).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                //Go back to StartOrWatchMeetingViewController at index 2
                if let popBackToThisViewController = self.navigationController?.viewControllers[2] {
                    self.navigationController?.popToViewController(popBackToThisViewController, animated: true)
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    //Tilføj emner på dagsordenen
    @IBAction func addTopicButton(_ sender: UIBarButtonItem) {
        addToQuestionsArray(newQuestion: "")
    }
    
    //Tilføj mødepunkt til arrayet
    func addToQuestionsArray(newQuestion : String) {
        questionsArray.append(newQuestion)
        let indexPath = IndexPath(row: questionsArray.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToBottomRow()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableView)
        let textFieldIndexPath = self.tableView.indexPathForRow(at: pointInTable)!
        tableView(self.tableView, didSelectRowAt: textFieldIndexPath)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        questionsArray[currentlySelectedTextfield] = textField.text!
    }
    
    //Skal oprette questions (agenda) under meeting id'et
    @IBAction func createMeetingButton(_ sender: Any) {
        
        //Tilføj standardspørgsmål lige inden upload så de ligger sidst i arrayet.
        self.view.endEditing(true)
        
        //Prepare data for upload
        var data = [String : Any]()
        let questionsAmount = questionsArray.count
        
        //Add meeting leaders questions
        if questionsAmount > 0 {
            for index in 1...questionsAmount {
                data[String(index)] = questionsArray[index-1]
            }
        }
        
        //Add standard questions that should be answered after the ones the meeting leader has added
        data[String(questionsAmount + 1)] = MEETING_Q_1
        data[String(questionsAmount + 2)] = MEETING_Q_2
        data[String(questionsAmount + 3)] = MEETING_Q_3
        data[String(questionsAmount + 4)] = MEETING_Q_4
        data[String(questionsAmount + 5)] = MEETING_Q_5
        data[String(questionsAmount + 6)] = MEETING_Q_6
        let amount = data.count
        data[DB_AMOUNT] = amount
        
        //Upload data and go to next screen (This should be the corresponding feedback page
        agendaCollectionsRef.document(meetingIdString).collection(AGENDA_REF).document(AGENDA_QUESTIONS_REF).setData(data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
            else {
                self.defaults.set(STATISTICS_CAME_FROM_CREATE_MEETING, forKey: STATISTICS_CAME_FROM_THIS_SCREEN)
                self.defaults.set(self.meetingIdString, forKey: STATISTICS_MEETING_ID_KEY)
                self.performSegue(withIdentifier: "goToMeetingStatistics", sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "yoshikoCreateMeetingCell", for: indexPath) as? YoshikoCreateMeetingTableViewCell {
            cell.configureCell(placeholder: "Mødepunkt \(indexPath.row + 1)")
            layoutTextfields(textfield: cell.userWillInputField)
            cell.userWillInputField.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentlySelectedTextfield = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            questionsArray.remove(at: indexPath.row)
            tableView.beginUpdates()
            let newIndexPath = IndexPath(row: indexPath.row, section: 0)
            tableView.deleteRows(at: [newIndexPath], with: .automatic)
            tableView.endUpdates()
            tableView.reloadData()
            currentlySelectedTextfield = 0
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

//Code borrowed from : https://stackoverflow.com/questions/33705371/how-to-scroll-to-the-exact-end-of-the-uitableview
extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            
            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)
            
            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                
                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            
            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }
            
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}
