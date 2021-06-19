//
//  ViewController.swift
//  StormViewer
//
//  Created by Igor Chernyshov on 18.06.2021.
//

import UIKit

class ViewController: UITableViewController {

	private var picturesPaths: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Storm View"
		navigationController?.navigationBar.prefersLargeTitles = true

		let fm = FileManager.default
		guard let path = Bundle.main.resourcePath,
			  let items = try? fm.contentsOfDirectory(atPath: path) else { return }

		for item in items {
			if item.hasPrefix("nssl") {
				picturesPaths.append(item)
			}
		}
		picturesPaths.sort()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		picturesPaths.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = picturesPaths[indexPath.row]
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let detailViewController = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController else { return }
		detailViewController.selectedImage = picturesPaths[indexPath.row]
		detailViewController.title = "Picture \(indexPath.row + 1) of \(picturesPaths.count)"
		navigationController?.pushViewController(detailViewController, animated: true)
	}
}
