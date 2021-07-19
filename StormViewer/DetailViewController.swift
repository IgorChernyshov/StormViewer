//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Igor Chernyshov on 18.06.2021.
//

import UIKit

final class DetailViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet var imageView: UIImageView!

	// MARK: - Properties
	var selectedImage: String?

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()

		assert(selectedImage != nil, "Selected image must not be nil")
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

		guard let imagePath = selectedImage else { return }
		imageView.image = UIImage(named: imagePath)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.hidesBarsOnTap = false
		super.viewWillDisappear(animated)
	}

	@objc func shareTapped() {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
			print("No image found")
			return
		}

		let viewController = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: [])
		viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(viewController, animated: true)
	}
}
