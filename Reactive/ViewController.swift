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
import enum Result.NoError

class ViewController: UIViewController {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var label: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let textSignal = textField.reactive.continuousTextValues
		let isHiddenSignal = textSignal.skipNil().map { ($0.characters.count) < 6 }
		
		label.reactive.isHidden <~ isHiddenSignal
		label.reactive.text <~ textSignal
	}
}

