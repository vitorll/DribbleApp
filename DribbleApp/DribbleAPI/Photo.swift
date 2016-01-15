
import Foundation

// Dribble shots API Docs: http://developer.dribbble.com/v1/shots/
// Model for shots object from Dribble API
// We are not getting all information, just the ones we need

class Photo {
    var id : Int?
    var title : String?
    var date : String?
    var description : String?
    var commentCount : Int?
    var likesCount :  Int?
    var viewsCount : Int?
    var commentUrl : String?
    var imageUrl : NSURL?
    var imageData : NSData?
    var user: User?
    
    init(data : NSDictionary){
        
        self.id = data["id"] as? Int
        self.commentCount = data["comments_count"] as? Int
        self.likesCount = data["likes_count"] as? Int
        self.viewsCount = data["views_count"] as? Int
        
        self.commentUrl = Utils.getStringFromJSON(data, key: "comments_url")
        self.title = Utils.getStringFromJSON(data, key: "title")
        
        let dateInfo = Utils.getStringFromJSON(data, key: "created_at")
        self.date = Utils.formatDate(dateInfo)
        
        let desc = Utils.getStringFromJSON(data, key: "description")
        self.description = Utils.stripHTML(desc)
        
        if let images = data["images"] as? NSDictionary {
            self.imageUrl = NSURL(string: Utils.getStringFromJSON(images, key: "normal"))
        }
        
        if let userData = data["user"] as? NSDictionary {
            self.user = User(data: userData)
        }
    }
}
