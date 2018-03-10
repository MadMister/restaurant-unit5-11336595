//
//  OrederConfirmationViewController.swift
//  restaurant
//
//  Created by Jan Marten Sevenster on 10/03/2018.
//  Copyright © 2018 John Appleseed. All rights reserved.
//

import UIKit

class OrederConfirmationViewController: UIViewController {
    var minutes: Int!

@IBOutlet weak var timeRemainingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemainingLabel.text = "Thank you for your order! Your wait time is approximately \(minutes!) minutes."
    }
    // fill in the label text
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
