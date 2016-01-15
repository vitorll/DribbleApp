
import Foundation

// Dribble user API Docs: http://developer.dribbble.com/v1/users/
// Model for user object from Dribble API
// We are not getting all information, just the ones we need

class User {
    var userId : Int?
    var avatarUrl : String?
    var name : String?
    var location : String?
    var followingCount : Int?
    var followersCount : Int?
    var photosCount : Int?
    var photosUrl : String?
    var followingUrl : String?
    var avatarData : NSData?
    
    init(data : NSDictionary){
        self.userId = data["id"] as? Int
        self.name = Utils.getStringFromJSON(data, key: "name")
        self.avatarUrl = Utils.getStringFromJSON(data, key: "avatar_url")
        
        self.location = Utils.getStringFromJSON(data, key: "location")
        self.followingCount = data["followings_count"] as? Int
        self.followersCount = data["followers_count"] as? Int
        self.photosCount = data["shots_count"] as? Int
        
        self.photosUrl = Utils.getStringFromJSON(data, key: "shots_url")
        self.followingUrl = Utils.getStringFromJSON(data, key: "following_url")
    }
}