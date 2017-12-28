//
//  EventDetailViewController.swift
//  Promotional App
//
//  Created by Heady on 29/12/17.
//  Copyright © 2017 Heady. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var textViewDescription: UITextView!
    var event: Event! 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = event.name ?? ""
        self.textViewDescription.text = event.small_description ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
