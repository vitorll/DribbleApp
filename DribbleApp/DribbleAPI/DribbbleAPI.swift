
import Foundation

// Dribble API Docs: http://developer.dribbble.com/v1/
// Main class for getting access to dribble data

let followeeField = "followee"

class DribbbleAPI {

    func loadPhotos(photosUrlString: String, completion: (([Photo]) -> Void)) {
        let urlString = photosUrlString + C.URL.urlPathForImages

        let session = NSURLSession.sharedSession()
        if let photosUrl = NSURL(string: urlString) {
            
            // Open session to load images from dribble
            let task = session.dataTaskWithURL(photosUrl){ (data, response, error) -> Void in
                
                if error != nil {
                    print(error?.localizedDescription)
                    
                } else {
                    
                    if let photoData = data {
                        let photos = self.getPhotosFromData(photoData)

                        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(photos)
                            }
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    // Parse photos result from dribble API
    func getPhotosFromData(data: NSData) -> [Photo] {
        do {
            var photos = [Photo]()
            
            if let photosData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray {
                for photo in photosData {
                    if let photoDict = photo as? NSDictionary {
                        let photo = Photo(data: photoDict)
                        photos.append(photo)
                    }
                }
            }
            
            return photos
        }catch let error{
            print(error)
        }
        
        return [Photo]()
    }
    
    func loadPhotosForBucket(photosUrlString: String, completion: (([Photo]) -> Void)!) {
        let urlString = C.URL.bucketPath + photosUrlString + C.URL.urlPathForImages
        
        let session = NSURLSession.sharedSession()
        if let photosUrl = NSURL(string: urlString) {
            let task = session.dataTaskWithURL(photosUrl){
                (data, response, error) -> Void in
                
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    
                    if let photoData = data {
                        let photos = self.getPhotosFromData(photoData)

                        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(photos)
                            }
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func loadComments(commentsUrl: String, completion: (([Comment]) -> Void)!) {
        
        let urlString = commentsUrl + C.URL.accessTokenPath + C.dribbleAPIAccessToken
        let session = NSURLSession.sharedSession()
        
        if let url = NSURL(string: urlString) {
            let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    var comments = [Comment]()
                    
                    // Parse comments response
                    do{
                        if let optData = data as NSData? {
                            if let commentsData = try NSJSONSerialization.JSONObjectWithData(optData, options: .MutableContainers) as? NSArray {
                                for commentData in commentsData {
                                    let comment = Comment(data: commentData as! NSDictionary)
                                    comments.append(comment)
                                }
                            }
                        }
                    }catch let error {
                        print(error)
                    }
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(comments)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func loadUsers(usersUrl: String, completion: (([User]) -> Void)!) {

        let urlString = usersUrl + C.URL.accessTokenPath + C.dribbleAPIAccessToken
        
        let session = NSURLSession.sharedSession()
        if let url = NSURL(string: urlString) {
            let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in

                if error != nil {
                    print(error!.localizedDescription)
                } else {

                    var users = [User]()
                    do {
                        if let optData = data as NSData? {
                            if let usersData = try NSJSONSerialization.JSONObjectWithData(optData, options: .MutableContainers) as? NSArray {
                                
                                for userData in usersData{
                                    if let foloweeDict = userData[followeeField] as? NSDictionary {
                                        let user = User(data: foloweeDict)
                                        users.append(user)
                                    }
                                }
                            }
                        }
                    } catch let error {
                        print(error)
                    }
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(users)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}
