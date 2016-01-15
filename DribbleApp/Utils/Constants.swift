
import UIKit
import Foundation

// Constants struct for quick access to static information

struct C {
    static let dribbleAPIAccessToken = "CHANGE THIS TO YOUR DRIBBLE API ACCESS TOKEN"
    static let storyboard = UIStoryboard(name: "Main", bundle: nil)
    static let sampleBuckets = ["245303--1", "326320-brand", "199623-inspiration", "76199--game"]
    
    struct URL {
        static let baseURL = "https://api.dribbble.com/v1/"
        static let bucketPath = baseURL + "buckets/"
        static let accessTokenPath = "?access_token="
        static let urlPathForImages = accessTokenPath + C.dribbleAPIAccessToken + "&page=1&per_page=100"
    }
    
    struct ViewController {
        static let photoDetail = "PhotoDetailController"
        static let profile = "ProfileViewController"
    }
    
    struct SegueIdentifier {
        static let photoDetail = "details"
        static let profile = "profile"
    }
    
    struct Cell {
        static let dribbleCell = "DribbleCell"
        static let customCell = "Cell"
        static let commentCell = "CommentCell"
    }
}