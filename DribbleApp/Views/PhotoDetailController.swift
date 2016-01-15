
import Foundation
import UIKit

class PhotoDetailController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- View Constants

    let heightForTopLayout: CGFloat = 240.0
    let nameFontSize: CGFloat = 16.0
    let titleFontSize: CGFloat = 21.0
    let dateFontSize: CGFloat = 10.0
    
    let profileImageCornerRadius: CGFloat = 18.0
    
    let statsCountFontSize : CGFloat = 16
    let statsLabelFontSize : CGFloat = 12
    let statsCountColor = UIColor(red: 0.32, green: 0.61, blue: 0.94, alpha: 1.0)
    let statsLabelColor = UIColor(white: 0.7, alpha: 1.0)
    
    let baseCommentCellHeight: CGFloat = 100.0
    
    let frameForGradientView = CGRectMake(0, 0, 1000, 90)
    let colorsForGradient = [UIColor(white: 0.0, alpha: 0.0).CGColor, UIColor(white: 0.0, alpha: 0.5).CGColor]
    
    // MARK:- View Outlets
    
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var dateLabel : UILabel?
    @IBOutlet var topImageView : UIImageView?
    @IBOutlet var topGradientView : UIView?
    @IBOutlet var dateImageView : UIImageView?
    @IBOutlet var backbutton : UIButton?
    @IBOutlet var profileImageView : UIImageView?
    @IBOutlet var nameLabel : UILabel?
    @IBOutlet var descriptionLabel : UILabel?
    @IBOutlet var commentTableView : UITableView?
    @IBOutlet var viewsCount : UILabel?
    @IBOutlet var viewsLabel : UILabel?
    @IBOutlet var likesCount : UILabel?
    @IBOutlet var likesLabel : UILabel?
    @IBOutlet var commentsCount : UILabel?
    @IBOutlet var commentsLabel : UILabel?
    @IBOutlet var topImageViewHeightConstraint : NSLayoutConstraint?
    
    var photo : Photo?
    var comments : [Comment] = [Comment]()
    
    var photos : [String]?
    
    // MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewData()
        setupGestureRecognizers()

        let api = DribbbleAPI()
        
        if let commentUrl = photo?.commentUrl {
            api.loadComments(commentUrl, completion: didLoadComments)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addPhotoGradient()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    //MARK:- Custom Methods
    
    func backTapped(sender: AnyObject?){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addPhotoGradient(){
        
        topGradientView?.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frameForGradientView
        gradientLayer.colors = colorsForGradient
        
        self.topGradientView?.layer.addSublayer(gradientLayer)
    }
    
    func profileTapped(){
        performSegueWithIdentifier(C.SegueIdentifier.profile, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == C.SegueIdentifier.profile {

            if let controller = segue.destinationViewController as? ProfileViewController {
                controller.user = photo?.user
            }
        }
    }
    
    func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "profileTapped")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        nameLabel?.userInteractionEnabled = true
        nameLabel?.addGestureRecognizer(tapGesture)
        
        let tapGestureAvatar = UITapGestureRecognizer(target: self, action: "profileTapped")
        tapGestureAvatar.numberOfTapsRequired = 1
        tapGestureAvatar.numberOfTouchesRequired = 1
        profileImageView?.userInteractionEnabled = true
        profileImageView?.addGestureRecognizer(tapGestureAvatar)
    }
    
    func setupViewData() {
        title = photo?.title
        
        titleLabel?.font = UIFont(name: Theme.fontName, size: titleFontSize)
        titleLabel?.textColor = UIColor.whiteColor()
        titleLabel?.text = photo?.title
        
        dateLabel?.font = UIFont(name: Theme.fontName, size: dateFontSize)
        dateLabel?.textColor = UIColor.whiteColor()
        dateLabel?.text = photo?.date
        
        dateImageView?.image = UIImage(named: "clock")?.imageWithRenderingMode(.AlwaysTemplate)
        dateImageView?.tintColor = UIColor.whiteColor()
        
        if let photoOpt = photo {
            if let imageData = photoOpt.imageData {
                topImageView?.image = UIImage(data: imageData)
            }else{
                Utils.asyncLoadPhotoImage(photoOpt, imageView: topImageView)
            }
        }
        
        nameLabel?.font = UIFont(name: Theme.fontName, size: nameFontSize)
        nameLabel?.textColor = UIColor.blackColor()
        
        if let userName = photo?.user?.name {
            nameLabel?.text = "by " + userName
        }
        
        if let user = photo?.user {
            Utils.asyncLoadUserImage(user, imageView: profileImageView)
        }
        profileImageView?.layer.cornerRadius = profileImageCornerRadius
        profileImageView?.clipsToBounds = true

        viewsCount?.font = UIFont(name: Theme.boldFontName, size: statsCountFontSize)
        viewsCount?.textColor = statsCountColor

        if let views = photo?.viewsCount {
            viewsCount?.text = "\(views)"
        }
        
        viewsLabel?.font = UIFont(name: Theme.fontName, size: statsLabelFontSize)
        viewsLabel?.textColor = statsLabelColor
        viewsLabel?.text = "VIEWS"
        
        likesCount?.font = UIFont(name: Theme.boldFontName, size: statsCountFontSize)
        likesCount?.textColor = statsCountColor
        
        if let likes = photo?.likesCount {
            likesCount?.text = "\(likes)"
        }
        
        likesLabel?.font = UIFont(name: Theme.fontName, size: statsLabelFontSize)
        likesLabel?.textColor = statsLabelColor
        likesLabel?.text = "LIKES"
        
        commentsCount?.font = UIFont(name: Theme.boldFontName, size: statsCountFontSize)
        commentsCount?.textColor = statsCountColor

        if let comments = photo?.commentCount {
            commentsCount?.text = "\(comments)"
        }
        
        commentsLabel?.font = UIFont(name: Theme.fontName, size: statsLabelFontSize)
        commentsLabel?.textColor = statsLabelColor
        commentsLabel?.text = "COMMENTS"
        
        commentTableView?.delegate = self
        commentTableView?.dataSource = self
        commentTableView?.estimatedRowHeight = baseCommentCellHeight;
        commentTableView?.rowHeight = UITableViewAutomaticDimension;
        
        topImageViewHeightConstraint?.constant = heightForTopLayout
    }
    
    func didLoadComments(comments: [Comment]){
        self.comments = comments
        commentTableView?.reloadData()
    }
        
    // MARK:- TableView DataSource & Delegates
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(C.Cell.commentCell) as? CommentCell {
            let comment = comments[indexPath.row]
            
            cell.nameLabel?.text = comment.user?.name
            cell.postLabel?.text = comment.body
            cell.dateLabel?.text = comment.date
            
            if let user = comment.user {
                Utils.asyncLoadUserImage(user, imageView: cell.profileImageView)
            }

            return cell
        }
        
        return CommentCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
}
