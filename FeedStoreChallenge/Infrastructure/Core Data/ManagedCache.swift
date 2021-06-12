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
internal final class ManagedCache: NSManagedObject {
	@NSManaged internal var timestamp: Date
	@NSManaged internal var feed: NSOrderedSet

	internal var localFeed: [LocalFeedImage] {
		return self.feed.compactMap { ($0 as? ManagedFeedImage)?.local }
	}

	internal static func find() throws -> ManagedCache? {
		try ManagedCache.fetchRequest().execute().first as? ManagedCache
	}
}
