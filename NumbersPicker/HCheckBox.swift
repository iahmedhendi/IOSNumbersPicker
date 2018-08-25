//
//  HCheckBox.swift
//  NumbersPicker
//
//  Created by Hendi on 8/25/18.
//  Copyright © 2018 Hendi. All rights reserved.
//


import Foundation
import UIKit
class HCheckBox: UIButton {
    var hSelected = false {
        didSet {
            if hSelected {
                if imageView != nil {
                    self.setImage(checkedImage, for: .normal)
                } else {
                    self.setImage(checkedImage, for: .normal)
                    print("image null")
                }
                
            }
        }
    }
    
    var checkedImage: UIImage!, unCheckedImage: UIImage!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupView()
    }
    
    func setupView() {
        tintColor = UIColor.darkGray
        checkedImage = #imageLiteral(resourceName: "check_circle_black").maskWithColor(color: tintColor)
        unCheckedImage = #imageLiteral(resourceName: "check_circle_outline").maskWithColor(color: tintColor)
        setImage(unCheckedImage, for: .normal)
        
        self.onTap {
            if self.hSelected {
                self.setImage(self.unCheckedImage, for: .normal)
                self.hSelected = false
            } else {
                self.setImage(self.checkedImage, for: .normal)
                
                self.hSelected = true
            }
            
        }
    }
    
    
}
