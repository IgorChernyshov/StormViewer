//
//  ViewController.swift
//  StormViewer
//
//  Created by Igor Chernyshov on 18.06.2021.
//

import UIKit

class ViewController: UITableViewController {

	private var picturesPaths = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()

		let fm = FileManager.default
		guard let path = Bundle.main.resourcePath,
			  let items = try? fm.contentsOfDirectory(atPath: path) else { return }

		for item in items {
			if item.hasPrefix("nssl") {
				picturesPaths.append(item)
			}
		}

		print("Pictures paths are \(picturesPaths)")
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		picturesPaths.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = picturesPaths[indexPath.row]
		return cell
	}
}

