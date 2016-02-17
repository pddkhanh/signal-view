//
//  ViewController.swift
//  SignalViewDemo
//
//  Created by Khanh Pham on 2/17/16.
//  Copyright © 2016 Khanh Pham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let signalView = view.viewWithTag(100) as! SignalStrengthView
        signalView.currentValue = -40
    }

}

