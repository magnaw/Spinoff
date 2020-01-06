//
//  MeetingsViewController.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 10/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import UIKit
import Firebase

class MeetingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Outlets
    @IBOutlet weak var meetingTableView: UITableView!
    
    //Variables
    let defaults = UserDefaults.standard
    private var meetings = [Meeting]()
    private var meetingsCollectionRef : CollectionReference!
    private var companyIdString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        meetingTableView.delegate = self
        meetingTableView.dataSource = self
        
        //Get the company ID from user defaults (Was stored on login, so should always work)
        if let companyIDFromUserDefaults = defaults.string(forKey: COMPANY_ID_KEY) {companyIdString = companyIDFromUserDefaults.lowercased()}
        
        self.defaults.set(STATICTICS_CAME_FROM_WATCH_MEETING, forKey: STATISTICS_CAME_FROM_THIS_SCREEN)
        
        meetingTableView.register(UINib(nibName: "WatchMeetingTableViewCell", bundle: nil), forCellReuseIdentifier: "watchMeetingTableViewCell")
        
        meetingsCollectionRef = Firestore.firestore().collection(COMPANY_REF).document(companyIdString).collection(MEETING_REF)
        
        //Tilbageknap
        let backImage = UIImage(named: IMAGE_BACKARROW)?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popNavigation))
    }
    
    @objc func popNavigation() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Used to do all the firebase stuff
    override func viewWillAppear(_ animated: Bool) {
        meetings.removeAll()
        meetingsCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("ERROR LOADING MEETING DOCUMENTS - \(error)")
            } else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    
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
                self.meetingTableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "watchMeetingTableViewCell", for: indexPath) as? WatchMeetingTableViewCell {
            cell.configureCell(meeting: meetings[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CONSTANTS_MEETING = meetings[indexPath.row]
        self.defaults.set(meetings[indexPath.row].meetingId, forKey: STATISTICS_MEETING_ID_KEY)
        print(meetings[indexPath.row].meetingId!)
        performSegue(withIdentifier: "goToMeetingStatisticsScreen", sender: self)
    }
}
