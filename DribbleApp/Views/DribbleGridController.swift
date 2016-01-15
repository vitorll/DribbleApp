
import Foundation
import UIKit

class DribbleGridController : UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    // MARK:- View Constants
    let bucketIds = C.sampleBuckets
    let layoutMinItemSpace: CGFloat = 0.0
    let layoutMinLineSpace: CGFloat = 0.0

    // MARK:- View Outlets
    @IBOutlet var collectionView : UICollectionView?
    @IBOutlet var layout : UICollectionViewFlowLayout?
    @IBOutlet weak var loadingView: UIView?
    
    var photos : [Photo]?
    var currentBucket = 0
    var cellHeight : CGFloat = 240
    var api : DribbbleAPI?
    
    // MARK:- View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Images"
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.clearColor()
        
        layout?.minimumInteritemSpacing = layoutMinItemSpace
        layout?.minimumLineSpacing = layoutMinLineSpace
        
        let cellWidth = calcCellWidth(self.view.frame.size)
        layout?.itemSize = CGSizeMake(cellWidth, cellHeight)
        
        self.photos = [Photo]()
        self.api = DribbbleAPI()
        self.currentBucket = 0
        
        getMorePhotosFromBuckets()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == C.SegueIdentifier.photoDetail) {
            let selectedItems = collectionView?.indexPathsForSelectedItems()
            
            if let sItem = selectedItems as [NSIndexPath]?{
                let photo = photos?[sItem[0].row]
                if let controller = segue.destinationViewController as? PhotoDetailController {
                    controller.photo = photo
                }
            }
        }
    }
    
    // Resize collection view items based on new screen size
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let cellWidth = calcCellWidth(size)
        layout?.itemSize = CGSizeMake(cellWidth, cellHeight)
    }
    
    //MARK:- Custom Methods
    
    func didLoadPhotos(loadedPhotos: [Photo]){
        
        // Load collectionView with dribble images
        for photo in loadedPhotos {
            self.photos?.append(photo)
        }
        
        collectionView?.reloadData()
    }
    
    func getMorePhotosFromBuckets(){
        
        // Ask dribbleAPI for images from some buckets
        if currentBucket < bucketIds.count {
            let url = bucketIds[currentBucket] + "/shots"
            api?.loadPhotosForBucket(url, completion: didLoadPhotos)
            
            currentBucket++
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if endScrolling >= scrollView.contentSize.height {
            getMorePhotosFromBuckets()
        }
    }
    
    // Check screen orientation and make cells use more or less space if needed
    func calcCellWidth(size: CGSize) -> CGFloat {
        let transitionToWide = size.width > size.height
        var cellWidth = size.width / 2
        
        if transitionToWide {
            cellWidth = size.width / 3
        }
        
        return cellWidth
    }
    
    // MARK:- CollectionView DataSource & Delegates
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(C.Cell.dribbleCell, forIndexPath: indexPath) as? DribbleCell {
            if let photo = photos?[indexPath.row] {
                cell.titleLabel?.text = photo.title
                cell.nameLabel?.text = photo.user?.name

                // Do async load to not slow down the collection view UX
                Utils.asyncLoadDribbleCell(photo, cell: cell)
            }
            
            return cell
        }
        
        return DribbleCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photos = self.photos {
            if photos.count == 0 {
                loadingView?.hidden = false
            }
            else
            {
                loadingView?.hidden = true
                return photos.count
            }
        }
        
        loadingView?.hidden = false
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(C.SegueIdentifier.photoDetail, sender: self)
    }
}
