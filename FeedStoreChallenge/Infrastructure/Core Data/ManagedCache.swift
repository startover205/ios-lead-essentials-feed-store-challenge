//
//  ManagedCache.swift
//  FeedStoreChallenge
//
//  Created by Ming-Ta Yang on 2021/6/12.
//  Copyright © 2021 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedCache)
final class ManagedCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: NSOrderedSet

	var localFeed: [LocalFeedImage] {
		return self.feed.compactMap { ($0 as? ManagedFeedImage)?.local }
	}

	static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let request = ManagedCache.fetchRequest()
		request.returnsObjectsAsFaults = false
		return try context.fetch(request).first as? ManagedCache
	}

	static func deleteCachedFeedIfNeeded(in context: NSManagedObjectContext) throws {
		try ManagedCache.find(in: context).map(context.delete)
	}
}
