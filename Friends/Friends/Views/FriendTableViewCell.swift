//
//  FriendTableViewCell.swift
//  Friends
//
//  Created by Michael Redig on 5/16/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

	var friend: Friend? {
		didSet {
			updateViews()
		}
	}
	var networkHandler: NetworkHandler?

	func updateViews() {
		guard let friend = friend else { return }
		textLabel?.text = friend.name

		guard let url = URL(string: friend.imageURL) else { return }
		let request = URLRequest(url: url)
		networkHandler?.transferMahDatas(with: request, completion: { [weak self] (result: Result<Data, NetworkError>) in
			do {
				let data = try result.get()
				guard let image = UIImage(data: data) else { return }
				DispatchQueue.main.async {
					self?.imageView?.image = image
					self?.layoutSubviews()
					self?.roundCorners()
				}
			} catch {
				print(error)
			}
		})
	}

	private func roundCorners() {
		guard let imageView = imageView else { return }
		let smallerDimension = min(imageView.frame.size.width, imageView.frame.size.height)
		imageView.layer.cornerRadius = smallerDimension / 2
//		print(smallerDimension)
//		imageView.alpha = 0.1
		imageView.clipsToBounds = true
	}

}
