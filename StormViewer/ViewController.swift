//
//  ViewController.swift
//  StormViewer
//
//  Created by Igor Chernyshov on 18.06.2021.
//

import UIKit

class ViewController: UICollectionViewController {

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
			DispatchQueue.main.async {
				self?.collectionView.reloadData()
			}
		}
	}

	// MARK: - Selectors
	@objc func didTapShareButton() {
		let activityController = UIActivityViewController(activityItems: ["Check out the new StormViewer app!"], applicationActivities: nil)
		activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(activityController, animated: true)
	}
}

// MARK: - UICollectionViewDataSource
extension ViewController {

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		picturesPaths.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
			return UICollectionViewCell()
		}
		let pictureName = picturesPaths[indexPath.item]
		cell.nameLabel.text = pictureName

		let timesViewed = UserDefaults.standard.integer(forKey: pictureName)
		cell.timesViewedLabel.text = "Times viewed: \(timesViewed)"

		return cell
	}
}

// MARK: - UICollectionViewDelegate
extension ViewController {

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let detailViewController = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController else { return }
		let pictureName = picturesPaths[indexPath.item]

		let timesViewed = UserDefaults.standard.integer(forKey: pictureName)
		UserDefaults.standard.set(timesViewed + 1, forKey: pictureName)
		collectionView.reloadItems(at: [indexPath])

		detailViewController.selectedImage = pictureName
		detailViewController.title = "Picture \(indexPath.item + 1) of \(picturesPaths.count)"
		navigationController?.pushViewController(detailViewController, animated: UIView.areAnimationsEnabled)
	}
}
