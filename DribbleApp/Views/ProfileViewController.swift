
import Foundation
import UIKit

class ProfileViewController : UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK:- View Constants
    let heightForZeroRows: CGFloat = 250
    let heightForOneRow: CGFloat = 400
    let heightForTwoRows: CGFloat = 100
    let heightForMoreRows: CGFloat = 44
    
    let frameForBlueView = CGRectMake(0, 0, 600, 100)
    
    let cornerRadiusForImagePreview: CGFloat = 20.0
    let cornerRadiusForAvatar: CGFloat = 35.0
    
    let nameFontSize: CGFloat = 20.0
    let locationFontSize: CGFloat = 12.0
    let photosFontSize: CGFloat = 14.0
    
    let photosBackgroundColor = UIColor(white: 0.92, alpha: 1.0)
    
    let photoLayoutItemSize = CGSizeMake(90, 90)
    let photoLayoutMinItemSpace: CGFloat = 5
    let photoLayoutMinLineSpace: CGFloat = 10
    
    let friendFontSize: CGFloat = 14.0
    
    let friendLayoutItemSize = CGSizeMake(45, 45)
    let friendLayoutMinItemSpace: CGFloat = 5
    let friendLayoutMinLineSpace: CGFloat = 10

    // MARK:- View Outlets
    @IBOutlet var bgImageView : UIImageView?
    @IBOutlet var profileImageView : UIImageView?
    @IBOutlet var profileContainer : UIView?
    @IBOutlet var nameLabel : UILabel?
    @IBOutlet var locationLabel : UILabel?
    @IBOutlet var locationImageView : UIImageView?
    @IBOutlet var followersLabel : UILabel?
    @IBOutlet var followersCount : UILabel?
    @IBOutlet var followingLabel : UILabel?
    @IBOutlet var followingCount : UILabel?
    @IBOutlet var photosLabel : UILabel?
    @IBOutlet var photosCount : UILabel?
    @IBOutlet var checkinsLabel : UILabel?
    @IBOutlet var friendsLabel : UILabel?
    @IBOutlet var photosContainer : UIView?
    @IBOutlet var photosCollectionLabel : UILabel?
    @IBOutlet var photosCollectionView : UICollectionView?
    @IBOutlet var photosLayout : UICollectionViewFlowLayout?
    @IBOutlet var friendsCollectionLabel : UILabel?
    @IBOutlet var friendsCollectionView : UICollectionView?
    @IBOutlet var friendsLayout : UICollectionViewFlowLayout?
    
    var user : User?
    var photos = [Photo]()
    var followingUsers = [User]()
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewData()

        let api = DribbbleAPI()
        
        if let photoUrl = user?.photosUrl {
            api.loadPhotos(photoUrl, completion: didLoadPhotos)
        }
        
        if let followingUrl = user?.followingUrl {
            api.loadUsers(followingUrl, completion: didLoadUsers)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }

    //MARK:- Custom Methods
    
    func setupViewData() {
        title = "Profile"
        
        if let avatarData = user?.avatarData {
            profileImageView?.image = UIImage(data: avatarData)
            bgImageView?.image = UIImage(data: avatarData)
        }else{
            if let userOpt = user {
                Utils.asyncLoadUserImage(userOpt, imageView: profileImageView)
            }
        }
        
        profileImageView?.layer.cornerRadius = cornerRadiusForAvatar
        profileImageView?.clipsToBounds = true
        
        nameLabel?.font = UIFont(name: Theme.fontName, size: nameFontSize)
        nameLabel?.textColor = UIColor.whiteColor()
        nameLabel?.text = user?.name
        
        locationLabel?.font = UIFont(name: Theme.fontName, size: locationFontSize)
        locationLabel?.textColor = UIColor.whiteColor()
        locationLabel?.text = user?.location
        
        locationImageView?.image = UIImage(named: "location")
        
        followingCount?.font = UIFont(name: Theme.boldFontName, size: Theme.statsCountFontSize)
        followingCount?.textColor = Theme.statsCountColor
        
        if let following = user?.followingCount {
            followingCount?.text = "\(following)"
        }
        
        followingLabel?.font = UIFont(name: Theme.fontName, size: Theme.statsLabelFontSize)
        followingLabel?.textColor = Theme.statsLabelColor
        followingLabel?.text = "FOLLOWING"
        
        followersCount?.font = UIFont(name: Theme.boldFontName, size: Theme.statsCountFontSize)
        followersCount?.textColor = Theme.statsCountColor
        
        if let followers = user?.followersCount {
            followersCount?.text = "\(followers)"
        }

        followersLabel?.font = UIFont(name: Theme.fontName, size: Theme.statsLabelFontSize)
        followersLabel?.textColor = Theme.statsLabelColor
        followersLabel?.text = "FOLLOWERS"
        
        photosCount?.font = UIFont(name: Theme.boldFontName, size: Theme.statsCountFontSize)
        photosCount?.textColor = Theme.statsCountColor
        
        if let count = user?.photosCount {
            photosCount?.text = "\(count)"
        }
        
        photosLabel?.font = UIFont(name: Theme.fontName, size: Theme.statsLabelFontSize)
        photosLabel?.textColor = Theme.statsLabelColor
        photosLabel?.text = "IMAGES"
        
        addBlurView()
        
        photosCollectionLabel?.font = UIFont(name: Theme.boldFontName, size: photosFontSize)
        photosCollectionLabel?.textColor = UIColor.blackColor()
        photosCollectionLabel?.text = "MY OTHER IMAGES"
        
        photosContainer?.backgroundColor = photosBackgroundColor
        
        photosCollectionView?.delegate = self
        photosCollectionView?.dataSource = self
        photosCollectionView?.backgroundColor = UIColor.clearColor()
        
        photosLayout?.itemSize = photoLayoutItemSize
        photosLayout?.sectionInset = UIEdgeInsetsZero
        photosLayout?.minimumInteritemSpacing = photoLayoutMinItemSpace
        photosLayout?.minimumLineSpacing = photoLayoutMinLineSpace
        photosLayout?.scrollDirection = .Horizontal
        
        friendsCollectionLabel?.font = UIFont(name: Theme.boldFontName, size: friendFontSize)
        friendsCollectionLabel?.textColor = UIColor.blackColor()
        friendsCollectionLabel?.text = "I FOLLOW THESE PEOPLE"
        
        friendsCollectionView?.delegate = self
        friendsCollectionView?.dataSource = self
        friendsCollectionView?.backgroundColor = UIColor.clearColor()
        
        friendsLayout?.itemSize = friendLayoutItemSize
        friendsLayout?.sectionInset = UIEdgeInsetsZero
        friendsLayout?.minimumInteritemSpacing = friendLayoutMinItemSpace
        friendsLayout?.minimumLineSpacing = friendLayoutMinLineSpace
        friendsLayout?.scrollDirection = .Horizontal
    }
    
    func addBlurView(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = frameForBlueView

        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        if let background = bgImageView {
            profileContainer?.insertSubview(blurView, aboveSubview: background)
        }
        
        if let conteinerView = profileContainer {
            let topConstraint = NSLayoutConstraint(item: conteinerView, attribute: .Top, relatedBy: .Equal, toItem: blurView, attribute: .Top, multiplier: 1.0, constant: 0.0)
            let bottomConstraint = NSLayoutConstraint(item: conteinerView, attribute: .Bottom, relatedBy: .Equal, toItem: blurView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
            let leftConstraint = NSLayoutConstraint(item: conteinerView, attribute: .Left, relatedBy: .Equal, toItem: blurView, attribute: .Left, multiplier: 1.0, constant: 0.0)
            let rightConstraint = NSLayoutConstraint(item: conteinerView, attribute: .Right, relatedBy: .Equal, toItem: blurView, attribute: .Right, multiplier: 1.0, constant: 0.0)
            
            self.profileContainer?.addConstraints([topConstraint, rightConstraint, leftConstraint, bottomConstraint])
        }
    }
    
    @IBAction func doneTapped(sender: AnyObject?){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didLoadPhotos(photos: [Photo]){
        self.photos = photos
        photosCollectionView?.reloadData()
    }
    
    func didLoadUsers(users: [User]){
        self.followingUsers = users
        friendsCollectionView?.reloadData()
    }
    
    // MARK:- TableView DataSource & Delegates
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            return heightForZeroRows
        }else if indexPath.row == 1 {
            return heightForOneRow
        }else if indexPath.row == 2 {
            return heightForTwoRows
        }else{
            return heightForMoreRows
        }
    }
    
    // MARK:- CollectionView DataSource & Delegates
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == photosCollectionView {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(C.Cell.dribbleCell, forIndexPath: indexPath) as? DribbleCell {
                let photo = photos[indexPath.row]
                Utils.asyncLoadDribbleCell(photo, cell: cell)
                
                return cell
            }
            
            return DribbleCell()
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(C.Cell.customCell, forIndexPath: indexPath) as UICollectionViewCell
            
            if let imageView = cell.viewWithTag(1) as? UIImageView {
                imageView.layer.cornerRadius = cornerRadiusForImagePreview
                let user = followingUsers[indexPath.row]
                
                if let data = user.avatarData {
                    imageView.image = UIImage(data: data)
                }else{
                    Utils.asyncLoadUserImage(user, imageView: imageView)
                }
            }
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photosCollectionView {
            return photos.count
        }else{
            return followingUsers.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == photosCollectionView {
            if let controller = C.storyboard.instantiateViewControllerWithIdentifier(C.ViewController.photoDetail) as? PhotoDetailController {
                let selectedItems = photosCollectionView?.indexPathsForSelectedItems()
                
                if let seletedIndexPath = selectedItems?.first {
                    let photo = photos[seletedIndexPath.row]
                    photo.user = user
                    controller.photo = photo
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else {
            if let controller = C.storyboard.instantiateViewControllerWithIdentifier(C.ViewController.profile) as? ProfileViewController {
                let selectedItems = friendsCollectionView?.indexPathsForSelectedItems()
                
                if let seletedIndexPath = selectedItems?.first {
                    let user = followingUsers[seletedIndexPath.row]
                    controller.user = user
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
}