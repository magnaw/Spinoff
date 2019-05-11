//
//  Constants.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 08/04/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

import Foundation
import UIKit

//FIREBASE
let COMPANY_REF = "companyid"
let MEETING_REF = "meeting"
let AGENDA_REF = "agenda"
let AGENDA_QUESTIONS_REF = "agendaQuestions"
let ANSWERS_REF = "answers"
let DB_AMOUNT = "amount"
let ERROR_LOADING_MEETING = "Der skete en fejl ved indlæsning af mødet"

//VARIOUS
let COMPANY_TITLE = "title"
let RANDOM_LETTERS_FOR_MEETING_ID = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

//MEETING
let MEETING_END_TIME = "endTime"
let MEETING_ID = "id"
let MEETING_LOCATION = "location"
let MEETING_START_TIME = "startTime"
let MEETING_TOPIC = "topic"

//UIDATEPICKER
let CHOOSE_DATE = "Vælg"
let CANCEL_DATE = "Annuller"

//UIALERTCONTROLLER
let ALERT_INPUT_MISSING_ERROR_TITLE = "Fejl"
let ALERT_INPUT_MISSING_ERROR_MESSAGE = "Venligst udfyld alle felter"
let ALERT_ACTION_TITLE_OK = "OK"
let ALERT_ACTION_TITLE_CANCEL = "Annuller"
let ALERT_ACTION_COMMENT = "Default action"
let ALERT_PROMPT_USER_FOR_NEW_INPUT_TITLE = "Tilføj mødepunkt"
let ALERT_PROMPT_USER_FOR_INPUT_TITLE = "Ændrer mødepunkt"
let ALERT_WRONG_MEETING_ID_MESSAGE = "Det indtastede møde ID eksisterer ikke"
let ALERT_WRONG_COMPANY_MESSAGE = "Den indtastede virksomhed eksisterer ikke i systemet"
let ALERT_TITLE_PLACEHOLDER = "Titel..."

//KEYS : DEFAULTS
let COMPANY_ID_KEY = "companyid"
let CREATE_MEETING_ID_KEY = "createmeetingid"
let JOIN_MEETING_ID_KEY = "joinmeetingid"
let STATISTICS_MEETING_ID_KEY = "statisticsmeetingid"

//PREVIOUS SCREEN (STATISTICS)
let STATISTICS_CAME_FROM_THIS_SCREEN = "previousscreenstatistics"
let STATISTICS_CAME_FROM_CREATE_MEETING = "camefromcreatemeeting"
let STATICTICS_CAME_FROM_WATCH_MEETING = "camefromwatchmeeting"


//MEETING STANDARD QUESTIONS
let MEETING_Q_1 = "Min vurdering af kvaliteten af mødet"
let MEETING_Q_2 = "Min vurdering af min mulighed for forberedelse"
let MEETING_Q_3 = "Min vurdering af mødeledelsen"
let MEETING_Q_4 = "Min vurdering af tidsstyring"
let MEETING_Q_5 = "Mit eget engagement som mødedeltager"
let MEETING_Q_6 = "Min overordnede vurdering af  mødet"
let MEETING_Q_AMOUNT = "amount"
let ERROR_LOADING_QUESTION = "Fejl ved hentning af spørgsmål"
let ERROR_LOADING_ANSWER = 1.0

//REGISTER COMPANY
let REGISTER_COMPANY_ALERT_TITLE = "Registrer virksomhed"
let REGISTER_COMPANY_DENIED = "Der skete end fejl, prøv igen"
let REGISTER_COMPANY_ACCEPTED = "Virksomheden er registreret, du kan nu logge ind"


//GENERALT TEXT AND TITLES
let STATISTICS_TITLE_MEETING_ID = "Møde ID"
let STATISTICS_TITLE_LOCATION = "Lokale"
let STATISTICS_TITLE_ERROR_LOADING = "Der skete en fejl"
let FEEDBACK_MEETING_POINT = "Mødepunkt"
let FEEDBACK_THANKS_FOR_FEEDBACK = "Tak for din feedback"
let FEEDBACK_LOG_OUT = "Log ud"


//IMAGES
let IMAGE_BACKARROW = "newarrow"



//LAYOUT : BUTTONS AND TEXTFIELDS
let LAYOUT_CORNERRADIUS : CGFloat = 20
let LAYOUT_BORDERWIDTH : CGFloat = 1.0
let LAYOUT_SHADOWOPACITY : Float = 1.0
let LAYOUT_SHADOWRADIUS : CGFloat = 10.0
let LAYOUT_MASKSTOBOUNDS = false
let LAYOUT_BORDERCOLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
let LAYOUT_SHADOWCOLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
let LAYOUT_SHADOWOFFSET = CGSize(width: 0, height: 3)


