
import Foundation
import UIKit

// Dribble comment API Docs: http://developer.dribbble.com/v1/shots/comments/
// Model for comment object from Dribble API
// We are not getting all information, just the ones we need

class Comment {
    var id : Int?
    var body : String?
    var date : String?
    var user : User?
    
    init(data : NSDictionary) {
        self.id = data["id"] as? Int
        let bodyHTML = Utils.getStringFromJSON(data, key: "body")
        self.body = Utils.stripHTML(bodyHTML)
        
        let dateInfo = Utils.getStringFromJSON(data, key: "created_at")
        self.date = Utils.formatDate(dateInfo)

        if let userData = data["user"] as? NSDictionary {
            self.user = User(data: userData)
        }
    }
}
