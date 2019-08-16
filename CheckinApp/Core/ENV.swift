//
//  ENV.swift
//  pacios
//
//  Created by Alan Guan on 3/9/19.
//  Copyright © 2019 Alan Guan. All rights reserved.
//

import Foundation


struct ENV {
    private static let URL = "https://checkin.hanyc.org"
//    private struct URL {
//        static let development = "http://pac.test"
//        static let production = "https://pac.hanyc.org"
//    }
    
    private struct Routes {
        static let events = "/api/events"
        static let attendees = "/api/attendees"
        static let event = "/api/event/"
        static let checkinAttendee = "/api/attendee/"
        static let loginAPI = "/login"
    }
    
    struct stripe {
        static let testPublishableKey = "pk_test_VFJelLeXhAjqy0ZJNMuSAWfL"
        
    }
    
    struct Domains {

        
        static let events = URL + Routes.events
        static let attendees = URL + Routes.attendees
        static let event = URL + Routes.event
        static let checkinAttendee = URL + Routes.checkinAttendee
        static let login = URL + Routes.loginAPI
        
//        struct Development {
//            static let pay = URL.development + Routes.payAPI
//            static let index = URL.development + Routes.indexAPI
//        }
//        
//        struct Production {
//            static let pay = URL.production + Routes.payAPI
//            static let index = URL.production + Routes.indexAPI
//        }
    }
    
   
}
