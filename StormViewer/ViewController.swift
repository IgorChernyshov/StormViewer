//
//  ViewController.swift
//  StormViewer
//
//  Created by Igor Chernyshov on 18.06.2021.
//

import UIKit

class ViewController: UITableViewController {

	private var picturesPaths: [String] = []

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Storm View"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))

		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			let fm = FileManager.default
			guard let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path) else { return }

			self?.picturesPaths = items.filter { $0.hasPrefix("nssl") }.sorted()
		}
	}

	// MARK: - Selectors
	@objc func didTapShareButton() {
		let activityController = UIActivityViewController(activityItems: ["Check out the new StormViewer app!"], applicationActivities: nil)
		activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(activityController, animated: true)
	}

	// MARK: - UITableViewDataSource
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		picturesPaths.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = picturesPaths[indexPath.row]
		return cell
	}

	// MARK: - UITableViewDelegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let detailViewController = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController else { return }
		detailViewController.selectedImage = picturesPaths[indexPath.row]
		detailViewController.title = "Picture \(indexPath.row + 1) of \(picturesPaths.count)"
		navigationController?.pushViewController(detailViewController, animated: true)
	}
}
