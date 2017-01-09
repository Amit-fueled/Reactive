//
//  ViewController.swift
//  Reactive
//
//  Created by Amit-Fueled on 09/01/17.
//  Copyright © 2017 Amit-Fueled. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class ViewController: UIViewController {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var label: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let signal = textField.reactive.continuousTextValues
	 
		signal.observeResult { (result) in
			guard let string = result.value else{
				return
			}
			self.label.text = string
		}
	}
}

