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

protocol Loader {
	var indictaorView : UIActivityIndicatorView? { get }
	func showLoader()
	func hideLoader()
}

extension Loader where Self: UIView {
	
	var indictaorView : UIActivityIndicatorView? {
		get { return subviews.filter { $0 is UIActivityIndicatorView }.first as? UIActivityIndicatorView }
	}
	
	func showLoader() {
		let indictaorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		indictaorView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
		let overlay = UIView(frame: bounds)
		overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		addSubview(overlay)
		addSubview(indictaorView)
		indictaorView.startAnimating()
	}
	
	func hideLoader(){
		guard let indictaorView = indictaorView else { return }
		indictaorView.stopAnimating()
		indictaorView.removeFromSuperview()
	}
}

extension UIButton: Loader{}

class ViewController: UIViewController {

	@IBOutlet weak var button: UIButton!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var label: UILabel!
	let buttonSignal = Signal<Bool, NoError>.pipe()

	let isApiCallExcecuting = MutableProperty<Bool>(false)
	
	@IBAction func didTapButton(_ sender: Any) {
		isApiCallExcecuting.value = true
		makeAPICall {
			self.isApiCallExcecuting.value = false
		}
	}

	func makeAPICall(_ handler: @escaping () -> Void) {
		let delay = DispatchTime.now() + 5
		DispatchQueue.main.asyncAfter(deadline: delay) {
			handler()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		button.reactive.shouldLoad <~ isApiCallExcecuting.producer
	}
}
extension Reactive where Base: UIButton {
		internal var shouldLoad: BindingTarget<Bool> {
		return makeBindingTarget {
			if let b = self.base as? Loader {
				if $1 {
					b.showLoader()
				} else {
					b.hideLoader()
				}
			}
		}
	}
}


