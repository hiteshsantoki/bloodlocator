//
//  ViewController.swift
//  BloodLocator
//
//  Created by Cronabit 1 on 29/09/17.
//  Copyright © 2017 Cronabit 1. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet var textfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "passdata"{
        let TC = segue.destination as? TableController
            if let svc = TC{
             svc.Searchdata = textfield.text
            }
        }
    }
 }

