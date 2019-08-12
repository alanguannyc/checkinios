//
//  ENV.swift
//  pacios
//
//  Created by Alan Guan on 3/9/19.
//  Copyright © 2019 Alan Guan. All rights reserved.
//

import Foundation


struct ENV {
    private static let URL = "https://pac.hanyc.org"
//    private struct URL {
//        static let development = "http://pac.test"
//        static let production = "https://pac.hanyc.org"
//    }
    
    private struct Routes {
        static let payAPI = "/iospay"
        static let indexAPI = "/api/donations"
        static let saveAPI = "/iossave"
        static let loginAPI = "/login"
    }
    
    struct stripe {
        static let testPublishableKey = "pk_test_VFJelLeXhAjqy0ZJNMuSAWfL"
        
    }
    
    struct Domains {

        
        static let pay = URL + Routes.payAPI
        static let index = URL + Routes.indexAPI
        static let save = URL + Routes.saveAPI
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