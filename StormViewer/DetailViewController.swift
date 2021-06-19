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

		navigationItem.largeTitleDisplayMode = .never

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
}
