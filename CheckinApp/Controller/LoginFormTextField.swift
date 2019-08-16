import UIKit

class LoginFormTextField: UITextField {


    override func draw(_ rect: CGRect) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.white.cgColor
        
        borderLayer.frame = CGRect(origin: CGPoint(x: 0.0, y: (self.frame.size.height)), size: CGSize(width: self.frame.size.width, height: 1.0))
        
        self.layer.addSublayer(borderLayer)
        
        self.leftViewMode = .always
    }
  

}
