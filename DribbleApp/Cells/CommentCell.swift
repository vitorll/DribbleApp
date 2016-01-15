
import Foundation
import UIKit

class CommentCell: UITableViewCell {
    
    // Cell Constants
    let dateImageAlpha: CGFloat = 0.20
    let profileImageRadius: CGFloat = 15
    let nameFontSize: CGFloat = 16
    let postFontSize: CGFloat = 12
    let dateFontSize: CGFloat = 11

    // Cell Outlets
    @IBOutlet var profileImageView : UIImageView?
    @IBOutlet var dateImageView : UIImageView?
    @IBOutlet var nameLabel : UILabel?
    @IBOutlet var postLabel : UILabel?
    @IBOutlet var dateLabel : UILabel?
    
    // Setup cell theme
    override func awakeFromNib() {
        dateImageView?.image = UIImage(named: "clock")
        dateImageView?.alpha = dateImageAlpha
        profileImageView?.layer.cornerRadius = profileImageRadius
        profileImageView?.clipsToBounds = true
        
        nameLabel?.font = UIFont(name: Theme.fontName, size: nameFontSize)
        nameLabel?.textColor = Theme.darkColor
        
        postLabel?.font = UIFont(name: Theme.fontName, size: postFontSize)
        postLabel?.textColor = Theme.lightColor
        
        dateLabel?.font = UIFont(name: Theme.fontName, size: dateFontSize)
        dateLabel?.textColor = Theme.lightColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        postLabel?.preferredMaxLayoutWidth = CGRectGetWidth(postLabel!.frame)
    }
    
    // Clean cell before reuse
    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel?.text = ""
        postLabel?.text = ""
        dateLabel?.text = ""
        profileImageView?.image = nil
    }
}