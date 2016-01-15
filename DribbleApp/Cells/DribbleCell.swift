
import Foundation
import UIKit

class DribbleCell: UICollectionViewCell {

    // Cell Constants
    let nameFontSize: CGFloat = 14
    let titleColor = UIColor(white: 0.45, alpha: 1.0)
    let titleFontSize: CGFloat = 11
    let coverImageBorderColor = UIColor(white: 0.2, alpha: 1.0)
    let coverBorderWidth: CGFloat = 0.5
    
    // Cell Outlets
    @IBOutlet var coverImageView : UIImageView?
    @IBOutlet var nameLabel : UILabel?
    @IBOutlet var titleLabel : UILabel?
    var imageUrl: NSURL?
    
    // Setup cell theme
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel?.textColor = UIColor.blackColor()
        nameLabel?.font = UIFont(name: Theme.fontName, size: nameFontSize)
        
        titleLabel?.textColor = titleColor
        titleLabel?.font = UIFont(name: Theme.fontName, size: titleFontSize)
        
        coverImageView?.layer.borderColor = coverImageBorderColor.CGColor
        coverImageView?.layer.borderWidth = coverBorderWidth
    }

    // Clean cell before reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel?.text = ""
        titleLabel?.text = ""
        coverImageView?.image = nil
        imageUrl = nil
    }
}