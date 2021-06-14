//
//  ManagedFeedImage.swift
//  FeedStoreChallenge
//
//  Created by Ming-Ta Yang on 2021/6/12.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedFeedImage)
final class ManagedFeedImage: NSManagedObject {
	@NSManaged var id: UUID
	@NSManaged var imageDescription: String?
	@NSManaged var location: String?
	@NSManaged var url: URL
	@NSManaged var cache: ManagedCache

	static func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
		NSOrderedSet(array: feed.map {
			let image = ManagedFeedImage(context: context)
			image.id = $0.id
			image.imageDescription = $0.description
			image.location = $0.location
			image.url = $0.url
			return image
		})
	}

	var local: LocalFeedImage {
		LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
	}
}
