//
//  ProfileCardViewController.swift
//  CheckinApp
//
//  Created by Alan on 8/12/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit
import Lottie
import NVActivityIndicatorView

protocol profileDelegation {
    func resetSearch()
}

class ProfileCardViewController: UIViewController {
    
    var profileDelegate : profileDelegation?
    
    let animationView = LOTAnimationView(name: "checkmark")
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        var cardview = createViewCard()
        cardview.center = view.center
        view.addSubview(cardview)
        
        
        animationView.center = self.view.center
        self.view.addSubview(animationView)
        
    }
    
    @IBOutlet weak var stackedContent: UIStackView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBAction func ConfirmButtonPressed(_ sender: Any) {
        createLoadingIndicator()
//        animationView.play { (true) in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                self.animationView.stop()
//            }
//
//        }
        
        
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    func createLoadingIndicator() {
        let width: CGFloat = 50
        let height: CGFloat = 50
        
        
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: width, height: height), type: .ballClipRotatePulse, color: .lightGray)
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        let timer2 = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            activityIndicatorView.stopAnimating()
            
            self.animationView.play { (true) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.animationView.stop()
                }
                
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           
            
        }
    }
    
    func createViewCard() -> UIView {
        let width: CGFloat = 250
        let height: CGFloat = 300
        
        let card = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
       card.backgroundColor = .white
        card.layer.shadowRadius = 5
        card.layer.shadowOffset = .zero
        card.layer.shadowOpacity = 1
        card.layer.shadowPath = UIBezierPath(rect: card.bounds).cgPath
        
        
        
        
        if let contentview = stackedContent {
            card.addSubview(contentview)
            contentview.centerXAnchor.constraint(equalTo: card.centerXAnchor).isActive = true
            contentview.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
            
        }
        
        return card
        
    }
    
}
