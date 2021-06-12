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
public class ManagedCache: NSManagedObject {
	@NSManaged public var timestamp: Date
	@NSManaged public var feed: NSOrderedSet
}
