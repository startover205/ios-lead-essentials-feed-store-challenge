//
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
	private static let modelName = "FeedStore"
	private static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

	private let container: NSPersistentContainer
	private let context: NSManagedObjectContext

	struct ModelNotFound: Error {
		let modelName: String
	}

	public init(storeURL: URL) throws {
		guard let model = CoreDataFeedStore.model else {
			throw ModelNotFound(modelName: CoreDataFeedStore.modelName)
		}

		container = try NSPersistentContainer.load(
			name: CoreDataFeedStore.modelName,
			model: model,
			url: storeURL
		)
		context = container.newBackgroundContext()
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		let context = self.context
		context.perform {
			let fetchRequest = ManagedCache.fetchRequest()
			do {
				if let cache = try fetchRequest.execute().first as? ManagedCache {
					completion(.found(feed: cache.feed
							.compactMap { $0 as? ManagedFeedImage }
							.map {
								LocalFeedImage(id: $0.id, description: $0.imageDescription, location: $0.location, url: $0.url)
							}, timestamp: cache.timestamp))
				} else {
					completion(.empty)
				}
			} catch {
				completion(.failure(error))
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		let context = self.context
		context.perform {
			let cache = ManagedCache(context: context)
			let managedFeed = feed.map { local -> ManagedFeedImage in
				let image = ManagedFeedImage(context: context)
				image.id = local.id
				image.imageDescription = local.description
				image.location = local.location
				image.url = local.url
				return image
			}
			cache.feed = NSOrderedSet(array: managedFeed)
			cache.timestamp = timestamp
			do {
				try context.save()
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}

	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		fatalError("Must be implemented")
	}
}
