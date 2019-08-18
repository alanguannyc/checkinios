//
//  LoginViewController.swift
//  pacios
//
//  Created by Alan Guan on 3/2/19.
//  Copyright © 2019 Alan Guan. All rights reserved.
//
struct KeychainConfiguration {
    static let serviceName = "TouchMeIn"
    static let accessGroup: String? = nil
}

import Alamofire
import UIKit
import SCLAlertView

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var touchIDButton: UIButton!
    
    
    var passwordItems: [KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    let touchMe = BiometricIDAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emailImageView = UIImageView();
        emailImageView.image = UIImage(named: "email.png");
        emailImageView.frame = CGRect(x: 0, y: 0, width: emailField.frame.height - 2.0, height: emailField.frame.height - 10.0)
        let passwordImageView = UIImageView()
        passwordImageView.image = UIImage(named: "password")
        passwordImageView.frame = CGRect(x: 0, y: 0, width: emailField.frame.height - 2.0, height: emailField.frame.height - 10.0)
        
        
        let emailPaddingView = UIView()
        emailPaddingView.frame = CGRect(x: 0, y: 0, width: emailField.frame.height, height: emailField.frame.height)
        emailPaddingView.addSubview(emailImageView)
        emailField.leftView = emailPaddingView;
        
        let passwordPaddingView = UIView()
        passwordPaddingView.frame = CGRect(x: 0, y: 0, width: passwordField.frame.height, height: passwordField.frame.height)
        passwordPaddingView.addSubview(passwordImageView)
        passwordField.leftView = passwordPaddingView
        
        touchIDButton.isHidden = !touchMe.canEvaluatePolicy()
        
        switch touchMe.biometricType()
        {
        case .touchID:
            touchIDButton.setImage(UIImage(named: "touchID"), for: .normal)
        case .faceID:
            touchIDButton.setImage(UIImage(named: "faceID"), for: .normal)
        case .none:
            return

        }
        
//        view.addSubview(emailImageView)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        guard
            let accountName = emailField.text,
            let accountPassword = passwordField.text,
            !accountName.isEmpty,
            !accountPassword.isEmpty
        else
            {
                showInfo("Email and Password are needed!")
                return
            }
    
        if sender.tag == createLoginButtonTag
        {
            let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
            if !hasLoginKey && emailField.hasText
            {
                UserDefaults.standard.set(accountName, forKey: "accountName")
            }
            
            do
            {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: accountName, accessGroup: KeychainConfiguration.accessGroup)
                
                try passwordItem.savePassword(accountPassword)
            }
            catch
            {
                fatalError("Cannot update Keychain")
            }
            
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            
            loginButton.tag = loginButtonTag
            
            authenticateUser(Email: emailField.text!, Password: passwordField.text!, URL: ENV.Domains.login)
            
        }
        else if sender.tag == loginButtonTag
        {
            
            checkLogin(accountName)
            
        }
        
        
    }
    
    @IBAction func touchIDButtonPressed(_ sender: Any) {
        let account = UserDefaults.standard.value(forKey: "accountName") as? String
        if (account != nil)
        {
            emailField.text = account
            
            touchMe.authenticateUser {
                [weak self] in
                self!.checkLogin(account!)
            }
            
        } else
        {
            showInfo("You must log in first.")
        }
        
        
    }
    
    
    func checkLogin(_ email: String)
    {
        let account = UserDefaults.standard.value(forKey: "accountName") as? String
        
        if (account != nil)
        {
            do
            {
                let passwordItem = KeychainPasswordItem(
                    service: KeychainConfiguration.serviceName,
                    account: email,
                    accessGroup: KeychainConfiguration.accessGroup
                )
                
                let savedPassword = try passwordItem.readPassword()
                
                authenticateUser(Email: account!, Password: savedPassword, URL: ENV.Domains.login)
                
            }
            catch
            {
                fatalError("no such account")
            }
        } else
        {
            do
            {
                let passwordItem = KeychainPasswordItem(
                    service: KeychainConfiguration.serviceName,
                    account: email,
                    accessGroup: KeychainConfiguration.accessGroup
                )
                
                let savedPassword = try passwordItem.readPassword()
                
                authenticateUser(Email: email, Password: savedPassword, URL: ENV.Domains.login)
                
            }
            catch
            {
                fatalError("no such account")
            }
        }
        
    }
    
    func authenticateUser(Email: String, Password: String, URL: String)
    {

        
        let params = [
            "email" : Email,
            "password" : Password,
        ]
        
        Alamofire.request(URL, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
            switch response.result {
            case .success:
                
                if let token = (response.result.value! as AnyObject)["api_token"]! {
                    UserDefaults.standard.set(token, forKey: "token")
                    self.directToMainPage()
                }
                self.directToMainPage()
            case .failure(let error):
                print(error)
                self.showInfo("Email or Password is not correct.")
            }
            
        }
    }
    
    func directToMainPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let intialVC = storyboard.instantiateInitialViewController()
        present(intialVC!, animated: true, completion: nil)
    }
    
    //MARK: - Show alerts
    func showInfo(_ Text:String){
        let alertView = SCLAlertView()
        let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
        }
        let timeOutAction = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 1, timeoutAction: timeoutAction)
        alertView.showInfo(Text, subTitle: "", timeout: timeOutAction)
    }
    
}
