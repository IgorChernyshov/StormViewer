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

		addWaterMark()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.hidesBarsOnTap = false
		super.viewWillDisappear(animated)
	}

	// MARK: - Actions
	@objc func shareTapped() {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
			print("No image found")
			return
		}

		let viewController = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: [])
		viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(viewController, animated: true)
	}

	// MARK: - Image Processing
	private func addWaterMark() {
		guard let displayedImage = imageView.image else { return }
		let imageSize = displayedImage.size
		let renderer = UIGraphicsImageRenderer(size: imageSize)

		let waterMarkedImage = renderer.image { context in
			displayedImage.draw(at: imageView.frame.origin)

			let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 32),
															 .foregroundColor: UIColor.black.withAlphaComponent(0.6),
															 .backgroundColor: UIColor.white.withAlphaComponent(0.6)]

			let string = " From Storm Viewer "
			let attributedString = NSAttributedString(string: string, attributes: attributes)

			attributedString.draw(with: CGRect(x: 32, y: imageSize.height - 48, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
		}

		imageView.image = waterMarkedImage
	}
}
