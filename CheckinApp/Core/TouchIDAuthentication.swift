//
//  TouchIDAuthentication.swift
//  pacios
//
//  Created by Alan on 3/15/19.
//  Copyright © 2019 Alan Guan. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType
{
    case none
    case touchID
    case faceID
}

class BiometricIDAuth {
    let context = LAContext()
    var loginReason = "Logging in with Touch ID"
    
    func canEvaluatePolicy() -> Bool
    {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricType
    {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch context.biometryType
        {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
            
        }
    }
    
    func authenticateUser(completion: @escaping() -> Void)
    {
        guard canEvaluatePolicy() else
        {
                return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, error) in
            if success
            {
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                
            }
        }
    }
    
}
