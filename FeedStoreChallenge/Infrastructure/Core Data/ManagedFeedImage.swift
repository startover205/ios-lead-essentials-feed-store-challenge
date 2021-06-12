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
internal final class ManagedFeedImage: NSManagedObject {
	@NSManaged internal var id: UUID
	@NSManaged internal var imageDescription: String?
	@NSManaged internal var location: String?
	@NSManaged internal var url: URL

	internal static func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
		NSOrderedSet(array: feed.map {
			let image = ManagedFeedImage(context: context)
			image.id = $0.id
			image.imageDescription = $0.description
			image.location = $0.location
			image.url = $0.url
			return image
		})
	}

	internal var local: LocalFeedImage {
		LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
	}
}
