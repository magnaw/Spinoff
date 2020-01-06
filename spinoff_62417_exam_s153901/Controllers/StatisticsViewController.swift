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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    
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
    private var meetings = [Meeting]()
    
    
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
        
        //Firebase
        meetingsCollectionRef = Firestore.firestore().collection(COMPANY_REF).document(companyIdString).collection(MEETING_REF)
        
        //Set the title
        navigationItem.title = "\(STATISTICS_TITLE_MEETING_ID): \(meetingIdString)"
        
        let backImage = UIImage(named: IMAGE_BACKARROW)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backToInitial(sender:)))
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //Meeting Info
        meetingsCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("ERROR LOADING MEETING DOCUMENTS - \(error)")
            } else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    let meetingId = data[MEETING_ID] as? String ?? ERROR_LOADING_MEETING
                    
                    if meetingId == self.meetingIdString {
                        let startDate = data[MEETING_START_TIME] as! Timestamp
                        let convertedStartDate = Date(timeIntervalSince1970: TimeInterval(startDate.seconds))
                        
                        let endDate = data[MEETING_END_TIME] as! Timestamp
                        let convertedEndDate = Date(timeIntervalSince1970: TimeInterval(endDate.seconds))
                        
                        let meetingTitle = data[MEETING_TOPIC] as? String ?? ERROR_LOADING_MEETING
                        let meetingRoom = data[MEETING_LOCATION] as? String ?? ERROR_LOADING_MEETING
                        let meetingId = data[MEETING_ID] as? String ?? ERROR_LOADING_MEETING
                        let documentId = document.documentID
                        
                        let newMeeting = Meeting(startDate: convertedStartDate, endDate: convertedEndDate, meetingTitle: meetingTitle, meetingRoom: meetingRoom, meetingId: meetingId, documentId: documentId)
                        self.meetings.append(newMeeting)
                    }
                }
                self.setTextOnLabels()
            }
        }
        
        //Questions
        meetingsCollectionRef.document(meetingIdString).collection(AGENDA_REF).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("ERROR LOADING MEETING DOCUMENTS - \(error)")
            } else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
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
                                let data = document.data()
                                for index in 1...self.numberOfQuestions {
                                    let num : Double = data["\(index)"] as? Double ?? ERROR_LOADING_ANSWER
                                    self.ratingArray[index - 1] = self.ratingArray[index - 1] + num
                                }
                                self.numberOfParticipants = self.numberOfParticipants + 1
                            }
                        }
                    }
                    if self.ratingsWasFound {
                        for index in 1...self.numberOfQuestions {
                            self.ratingArray[index - 1] = self.ratingArray[index - 1] / Double(self.numberOfParticipants)
                        }
                        self.ratingsWasFound = false
                    }
//                    print("UDREGNET ARRAY : \(self.ratingArray)")
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    
    func setTextOnLabels() {
        //Fix dates.
        let startText : String = "\(CONSTANTS_MEETING.startDate!)"
        let cutStartText = startText.dropLast(9)
        let endText : String = "\(CONSTANTS_MEETING.endDate!)"
        let cutEndText = endText.dropLast(9).dropFirst(11)
        let almostfinalText = "\(cutStartText) - \(cutEndText)"
        let finalText = "\(almostfinalText.dropLast(14))\n\(almostfinalText.dropFirst(11))"
        
        titleLabel.text = "\(STATISTICS_TITLE_MEETING): \(CONSTANTS_MEETING.meetingTitle!)"
        locationLabel.text = "\(STATISTICS_TITLE_LOCATION): \(CONSTANTS_MEETING.meetingRoom!)"
        startLabel.text = "\(finalText)"
    }
    
    //Code borrowed from : https://github.com/kharrison/CodeExamples/blob/master/TableHeader/TableHeaderSwift/TableHeader/ListTableViewController.swift
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
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
    
    func layoutView(view : UIView) {
        view.layer.shadowColor = LAYOUT_SHADOWCOLOR
        view.layer.shadowOffset = LAYOUT_SHADOWOFFSET
        view.layer.shadowOpacity = LAYOUT_SHADOWOPACITY
        view.layer.shadowRadius = LAYOUT_SHADOWRADIUS
        view.layer.masksToBounds = LAYOUT_MASKSTOBOUNDS
    }
}
