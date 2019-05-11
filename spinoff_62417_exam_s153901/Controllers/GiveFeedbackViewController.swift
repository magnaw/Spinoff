//
//  GiveFeedbackViewController.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 28/03/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit
import Cosmos
import Firebase

class GiveFeedbackViewController: UIViewController, UITextViewDelegate {

    //Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var agendaQuestionTextField: UITextView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var nextButton: UIButton!
    
    //Variables
    let defaults = UserDefaults.standard
    private var companyIdString : String = ""
    private var meetingIdString : String = ""
    private var meetingCollectionsRef : CollectionReference!
    //Questions
    private var numberOfQuestions : Int = 0
    private var currentQuestionNumber : Int = 0
    private var questionsArray : [String] = []
    //Rating
    private var ratingArray : [String : Any] = [:]
    private var currentRating : Double = 3.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agendaQuestionTextField.delegate = self
        
        //Layout
        layoutButton(button: nextButton)
        
        
        //Get the company ID from user defaults (Was stored on login, so should always work)
        if let companyIDFromUserDefaults = defaults.string(forKey: COMPANY_ID_KEY) {
            companyIdString = companyIDFromUserDefaults.lowercased()
        }
        if let meetingIDFromUserDefaults = defaults.string(forKey: JOIN_MEETING_ID_KEY) {
            meetingIdString = meetingIDFromUserDefaults
        }
        //Firebase reference
        meetingCollectionsRef = Firestore.firestore().collection(COMPANY_REF).document(companyIdString).collection(MEETING_REF)
        print("The road -> \(COMPANY_REF) -> \(companyIdString) -> \(MEETING_REF) -> \(meetingIdString) -> \(AGENDA_REF)")
        
        cosmosView.didTouchCosmos = {
            rating in print("Rated: \(rating)")
            self.currentRating = rating
//            print(self.currentRating)
        }
        headerLabel.text = ""
        agendaQuestionTextField.text = ""

        let backImage = UIImage(named: IMAGE_BACKARROW)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popNavigation))
    }
    
    @objc func popNavigation() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        meetingCollectionsRef.document(meetingIdString).collection(AGENDA_REF).getDocuments { (snapshot, error) in
            if let error = error {
                print("ERROR LOADING MEETING DOCUMENTS - \(error)")
            } else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    print("DOC !")
                    print(document)
                    let data = document.data()
                    let amount = data[MEETING_Q_AMOUNT] as? Int ?? 0
                    var newArray = [String]()
                    for index in 1...amount {
                        newArray.append(data["\(index)"] as? String ?? ERROR_LOADING_QUESTION)
                    }
//                    let documentId = document.documentID
                    print(newArray)
                    self.questionsArray = newArray
                    self.numberOfQuestions = amount
                    print("amount = \(amount)")
//                    self.agendaQuestions = Questions(questions: newArray, documentId: documentId)
                    
                    self.pushNextQuestion()
                    
                }
            }
        }
//        print("Her er vi -> \(agendaQuestions.questions[1])")
        
    }
    
    func pushNextQuestion() {
//        print("FØR : currentQuestionNumber = \(currentQuestionNumber), numberOfQuestions = \(numberOfQuestions)")
        if currentQuestionNumber < numberOfQuestions {
            headerLabel.text = "\(FEEDBACK_MEETING_POINT) \(currentQuestionNumber + 1)"
            agendaQuestionTextField.text = questionsArray[currentQuestionNumber]
        } else {
            //Push ratings to firebase
            meetingCollectionsRef.document(meetingIdString).collection(ANSWERS_REF).addDocument(data: ratingArray) {
                (error) in
                if let error = error {
                    debugPrint("Error adding document: \(error)")
                }
            }
            
            //Go to next screen
            headerLabel.text = ""
            agendaQuestionTextField.text = FEEDBACK_THANKS_FOR_FEEDBACK
            agendaQuestionTextField.textAlignment = .center
            cosmosView.isHidden = true
            nextButton.setTitle(FEEDBACK_LOG_OUT, for: .normal)
        }
        currentQuestionNumber = currentQuestionNumber + 1
        
//        print("EFTER : currentQuestionNumber = \(currentQuestionNumber), numberOfQuestions = \(numberOfQuestions)")
    }
    
    
    @IBAction func nextQuestionButton(_ sender: Any) {
        if currentQuestionNumber <= numberOfQuestions {
            //Push rating to array
            ratingArray[String(currentQuestionNumber)] = currentRating
            
            // Next question
            pushNextQuestion()
        } else {
            if let popBackToThisViewController = self.navigationController?.viewControllers[2] {
                self.navigationController?.popToViewController(popBackToThisViewController, animated: true)
            }
        }
        
        
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
