
// Reference code: http://www.splinter.com.au/2015/09/24/swift-image-cache/

import Foundation

class ImageCache {
    static let sharedCache: NSCache = {
        let cache = NSCache()
        cache.name = "ImageCache"
        cache.countLimit = 50 // Max 20 images in memory.
        cache.totalCostLimit = 10 * 1024 * 1024 // Max 10MB used.
        return cache
    }()
}
