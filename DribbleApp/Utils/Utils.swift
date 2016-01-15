
import Foundation
import UIKit

class Utils {
    
    // Load image photo Async
    // Exclusive for use with one imageView
    // For collectionView use asyncLoadDribbleCell
    
    class func asyncLoadPhotoImage(photo: Photo, imageView : UIImageView?) {
        let downloadQueue = dispatch_queue_create("com.DribbleApp.processsdownload", nil)
        
        dispatch_async(downloadQueue) {
            
            if let photoUrl = photo.imageUrl {
                let data = NSData(contentsOfURL: photoUrl)

                var image : UIImage?
                if let dataImage = data {
                    image = UIImage(data: dataImage)
                }
                downloadQueue.description
                dispatch_async(dispatch_get_main_queue()) {
                    imageView?.image = image
                }
            }
        }
    }
    
    // Load image photo Async
    // Best using with collectionView
    // For single purposes use asyncLoadPhotoImage

    // Reference code: http://www.splinter.com.au/2015/09/24/swift-image-cache/
    
    class func asyncLoadDribbleCell(photo: Photo, cell: DribbleCell?) {
        // Image loading.
        cell?.imageUrl = photo.imageUrl // For recycled cells' late image loads.
        if let image = photo.imageUrl?.cachedImage {
            // Cached: set immediately.
            cell?.coverImageView?.image = image
            cell?.coverImageView?.alpha = 1
        } else {
            // Not cached, so load then fade it in.
            cell?.coverImageView?.alpha = 0
            photo.imageUrl?.fetchImage { image in
                // Check the cell hasn't recycled while loading.
                if cell?.imageUrl == photo.imageUrl {
                    cell?.coverImageView?.image = image
                    UIView.animateWithDuration(0.3) {
                        cell?.coverImageView?.alpha = 1
                    }
                }
            }
        }
    }
    
    class func asyncLoadUserImage(user: User, imageView : UIImageView?){
        let downloadQueue = dispatch_queue_create("com.DribbleApp.processsdownload", nil)
        
        dispatch_async(downloadQueue) {
            
            if let avatarUrl = user.avatarUrl {
                if let url = NSURL(string: avatarUrl) {
                    let data = NSData(contentsOfURL: url)

                    var image : UIImage?
                    if let dataImage = data {
                        image = UIImage(data: dataImage)
                        user.avatarData = data
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        imageView?.image = image
                    }
                }
            }
        }
    }
    
    class func getStringFromJSON(data: NSDictionary, key: String) -> String{
        if let info = data[key] as? String {
            return info
        }
        return ""
    }
    
    // Remove HTML code from json strings
    class func stripHTML(str: NSString) -> String {
        var stringToStrip = str
        var r = stringToStrip.rangeOfString("<[^>]+>", options:.RegularExpressionSearch)
        while r.location != NSNotFound {
            
            stringToStrip = stringToStrip.stringByReplacingCharactersInRange(r, withString: "")
            r = stringToStrip.rangeOfString("<[^>]+>", options:.RegularExpressionSearch)
        }
        
        return stringToStrip as String
    }
    
    // Format date for better display
    class func formatDate(dateString: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.dateFromString(dateString) {
            
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter.stringFromDate(date)
        }
        
        return ""
    }
}
