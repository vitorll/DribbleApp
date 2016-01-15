
// Reference code: http://www.splinter.com.au/2015/09/24/swift-image-cache/

import Foundation
import UIKit

extension NSURL {
    typealias ImageCacheCompletion = UIImage -> Void
    
    /// Retrieves a pre-cached image, or nil if it isn't cached.
    /// You should call this before calling fetchImage.
    var cachedImage: UIImage? {
        return ImageCache.sharedCache.objectForKey(absoluteString) as? UIImage
    }
    
    /// Fetches the image from the network.
    /// Stores it in the cache if successful.
    /// Only calls completion on successful image download.
    /// Completion is called on the main thread.
    func fetchImage(completion: ImageCacheCompletion) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(self) { data, response, error in
            if error == nil {
                if let data = data, image = UIImage(data: data) {
                        ImageCache.sharedCache.setObject(image, forKey: self.absoluteString, cost: data.length)
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(image)
                        }
                }
            }
        }
        task.resume()
    }
}
