//
//  PopupCustomView.swift
//  ehss
//
//  Created by IOS1-PC on 30/05/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit

class PopupCustomView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var label: UILabel = UILabel()
    var listNames = ["test 1","test 2","test 3"]
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addCustomView();
    }
    
    required init(coder aDecoder: NSCoder){
            fatalError("init(coder: )has not implemented")
    }
    
    func addCustomView(){
        label.frame = CGRectMake(50,10,200,100)
        label.backgroundColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = "test label"
        label.hidden = true
        self.addSubview(label)
        
        let btn:UIButton = UIButton()
        btn.frame = CGRectMake(50, 120, 200, 100)
        btn.backgroundColor = UIColor.redColor()
        btn.setTitle("button", forState: UIControlState.Normal)
        btn.addTarget(self, action: "changeLabel", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(btn)
        
        let txtField: UITextField = UITextField()
        txtField.frame = CGRectMake(50, 250, 100, 50)
        txtField.backgroundColor = UIColor.grayColor()
        self.addSubview(txtField)
    
    }

}
