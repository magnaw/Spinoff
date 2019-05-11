//
//  StatisticsViewController.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 28/03/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit
import Firebase

class StatisticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    let defaults = UserDefaults.standard
    private var meetingsCollectionRef : CollectionReference!
    private var companyIdString : String = ""
    private var meetingIdString : String = ""
    private var previousScreenIdentification : String = STATISTICS_CAME_FROM_CREATE_MEETING
    
    private var numberOfQuestions : Int = 0
    private var numberOfParticipants : Int = 0
    private var questionsArray : [String] = []
    private var ratingArray : [Double] = []
    private var ratingsWasFound : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false //Doesnt make sense to be able to, as I haven't made any functionality for it
        
        tableView.register(UINib(nibName: "statisticsCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "statisticsCustomCell")
        
        //Get the company ID from user defaults (Was stored on login, so should always work)
        if let companyIDFromUserDefaults = defaults.string(forKey: COMPANY_ID_KEY) {companyIdString = companyIDFromUserDefaults.lowercased()}
        if let meetingIDFromUserDefaults = defaults.string(forKey: STATISTICS_MEETING_ID_KEY) {meetingIdString = meetingIDFromUserDefaults}
        if let previousScreenFromUserDefaults = defaults.string(forKey: STATISTICS_CAME_FROM_THIS_SCREEN) {previousScreenIdentification = previousScreenFromUserDefaults}
        meetingsCollectionRef = Firestore.firestore().collection(COMPANY_REF).document(companyIdString).collection(MEETING_REF)
        
        navigationItem.title = "\(STATISTICS_TITLE_MEETING_ID): \(meetingIdString)"
        
        let backImage = UIImage(named: IMAGE_BACKARROW)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backToInitial(sender:)))
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        //Questions
        meetingsCollectionRef.document(meetingIdString).collection(AGENDA_REF).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("ERROR LOADING MEETING DOCUMENTS - \(error)")
            } else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    print("DOC !")
                    print(document)
                    let data = document.data()
                    let amount = data[MEETING_Q_AMOUNT] as? Int ?? 1
                    var newArray = [String]()
                    for index in 1...amount {
                        newArray.append(data["\(index)"] as? String ?? ERROR_LOADING_QUESTION)
                    }
                    print(newArray)
                    self.questionsArray = newArray
                    self.numberOfQuestions = amount
                    
                    
                }
                //Answers
                
                
                
                self.meetingsCollectionRef.document(self.meetingIdString).collection(ANSWERS_REF).addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        print("ERROR LOADING MEETING DOCUMENTS - \(error)")
                    } else {
                        guard let snap = snapshot else {return}
                        //Fix array for correct values
                        self.ratingArray.removeAll()
                        self.numberOfParticipants = 0
                        if self.numberOfQuestions > 0 {
                            for _ in 1...self.numberOfQuestions {
                                self.ratingArray.append(0.0)
                            }
                            for document in snap.documents {
                                self.ratingsWasFound = true
                                print("DOC !")
                                print(document)
                                let data = document.data()
                                for index in 1...self.numberOfQuestions {
                                    let num : Double = data["\(index)"] as? Double ?? ERROR_LOADING_ANSWER
                                    self.ratingArray[index - 1] = self.ratingArray[index - 1] + num
                                }
                                self.numberOfParticipants = self.numberOfParticipants + 1
                                
                                print(self.ratingArray)
                                
                            }
                        }
                        
                        
                        
                        
                    }
                    if self.ratingsWasFound {
                        for index in 1...self.numberOfQuestions {
                            self.ratingArray[index - 1] = self.ratingArray[index - 1] / Double(self.numberOfParticipants)
                        }
                        self.ratingsWasFound = false
                    }
                    
                    print("UDREGNET ARRAY : \(self.ratingArray)")
                    self.tableView.reloadData()
                }
            }
            
        }
        

        
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "statisticsCell", for: indexPath) as? statisticsCell {
//            //            cell.configureCell(title: questionsArray[indexPath.row], rating: ratingArray[indexPath.row])
//            cell.configureCell(title: questionsArray[indexPath.row], rating: ratingArray[indexPath.row])
//            print(ratingArray[indexPath.row])
//            return cell
//        } else {
//            return UITableViewCell()
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "statisticsCustomCell", for: indexPath) as? statisticsCustomTableViewCell {
            //            cell.configureCell(title: questionsArray[indexPath.row], rating: ratingArray[indexPath.row])
            cell.configureCell(title: questionsArray[indexPath.row], rating: ratingArray[indexPath.row])
            layoutView(view: cell.contentViewOutlet)
            print(ratingArray[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    
    @objc func backToInitial(sender: AnyObject) {
        if previousScreenIdentification == STATISTICS_CAME_FROM_CREATE_MEETING {
            //Go back to StartOrWatchMeetingViewController at index 2
            if let popBackToThisViewController = self.navigationController?.viewControllers[2] {
                self.navigationController?.popToViewController(popBackToThisViewController, animated: true)
            }
        } else  {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    
    
    
    
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return questionsArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCustomQuestionCell", for: indexPath) as? MyCustomCreateQuestionCell {
//            cell.configureCell(title: "Mødepunkt \(indexPath.row + 1)", usersInput: self.questionsArray[indexPath.row])
//            return cell
//        } else {
//            return UITableViewCell()
//        }
//    }
    
    func layoutView(view : UIView) {
//        view.layer.cornerRadius = LAYOUT_CORNERRADIUS
        view.layer.shadowColor = LAYOUT_SHADOWCOLOR
        view.layer.shadowOffset = LAYOUT_SHADOWOFFSET
        view.layer.shadowOpacity = LAYOUT_SHADOWOPACITY
        view.layer.shadowRadius = LAYOUT_SHADOWRADIUS
        view.layer.masksToBounds = LAYOUT_MASKSTOBOUNDS
    }
    

    
}







////Questions
//meetingsCollectionRef.document(meetingIdString).collection(AGENDA_REF).getDocuments { (snapshot, error) in
//    if let error = error {
//        print("ERROR LOADING MEETING DOCUMENTS - \(error)")
//    } else {
//        guard let snap = snapshot else {return}
//        for document in snap.documents {
//            print("DOC !")
//            print(document)
//            let data = document.data()
//            let amount = data[MEETING_Q_AMOUNT] as? Int ?? 0
//            var newArray = [String]()
//            for index in 1...amount {
//                newArray.append(data["\(index)"] as? String ?? ERROR_LOADING_QUESTION)
//            }
//            print(newArray)
//            self.questionsArray = newArray
//            self.numberOfQuestions = amount
//
//
//        }
//        //Answers
//
//        for index in 1...self.numberOfQuestions {
//            self.ratingArray.append(0.0)
//        }
//
//        self.meetingsCollectionRef.document(self.meetingIdString).collection(ANSWERS_REF).getDocuments { (snapshot, error) in
//            if let error = error {
//                print("ERROR LOADING MEETING DOCUMENTS - \(error)")
//            } else {
//                guard let snap = snapshot else {return}
//                for document in snap.documents {
//                    print("DOC !")
//                    print(document)
//                    let data = document.data()
//                    for index in 1...self.numberOfQuestions {
//                        let num : Double = data["\(index)"] as? Double ?? ERROR_LOADING_ANSWER
//                        self.ratingArray[index - 1] = self.ratingArray[index - 1] + num
//                    }
//                    self.numberOfParticipants = self.numberOfParticipants + 1
//
//                    print(self.ratingArray)
//
//                }
//
//            }
//            for index in 1...self.numberOfQuestions {
//                self.ratingArray[index - 1] = self.ratingArray[index - 1] / Double(self.numberOfParticipants)
//            }
//            print("UDREGNET ARRAY : \(self.ratingArray)")
//            self.tableView.reloadData()
//        }
//    }
//
//}
