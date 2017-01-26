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
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var button: UIButton!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var label: UILabel!
	let buttonSignal = Signal<Bool, NoError>.pipe()
	var dataSource = MutableProperty<[String]>(["Amit"])
	let isApiCallExcecuting = MutableProperty<Bool>(false)
	let reuseIdentifier = "cell"
	
	@IBAction func didTapButton(_ sender: Any) {
		dataSource.value.append("Amit")
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
		tableView.dataSource = self
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 21
		
		tableView.reactive.shouldReLoad <~ dataSource.producer.map { value in
			return value.count > 0 ? true : false
		}
	}
}

extension ViewController: UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)	as UITableViewCell
		cell.textLabel?.text = dataSource.value[indexPath.row]
		return cell
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

extension Reactive where Base: UITableView {

	internal var shouldReLoad: BindingTarget<Bool> {
		return makeBindingTarget {
				if $1 {
					self.base.reloadData()
				}
		}
	}
}


