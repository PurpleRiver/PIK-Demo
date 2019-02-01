import UIKit
import GoogleMaps
import BonMot
import Alamofire

class DetailTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var detailLargeImage: UIImageView!
    @IBOutlet weak var detailNameTextLabel: UILabel! {
        didSet {
            detailNameTextLabel.text = detailsOfHouse.getName()
        }
    }
    
    @IBOutlet weak var bottomGradientMask: UIImageView!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    
    var detailsOfHouse: Product = Product()
    var features = [Feature]()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        navigationItem.title = detailsOfHouse.getName()
        
        prepereImage()
        setGradient()
        setCameraPosition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        customNavigationContoller()
    }
    
    // MARK: - Custom style for ViewController
    func customNavigationContoller() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setGradient() {
        
        bottomGradientMask.setGradientBackground(colorOne: UIColor.clear, colorTwo: UIColor.black)
        bottomGradientMask.alpha = 1
    }
    
    // MARK: - Fetching data for collection view.
    
    func fetchData() {
        Alamofire.request("https://my-json-server.typicode.com/PurpleRiver/fakeJsonServer/features").responseJSON { response in
            switch response.result {
            case .success:
                guard let string = String(data: response.data!, encoding: .utf8) else { return }
                print(string)
                
                guard let arrayOfFeatures = response.result.value as? [[String:AnyObject]]
                    else {
                        print("Cant make an array")
                        return
                }
                
                for feature in arrayOfFeatures {
                    
                    let parseFeature = Feature(name: feature["name"] as! String, image: feature["image"] as! String, description: feature["description"] as! String)
                    
                    self.features.append(parseFeature)
                }
                
            case .failure(let error):
                print(error)
            }
            // Get back to the main thread
            DispatchQueue.main.async {
                self.detailCollectionView.reloadData()
            }
        }
    }
    
    func prepereImage() {
        let imgUrl = NSURL(string: detailsOfHouse.getImage())
        
        if imgUrl != nil {
            let data = NSData(contentsOf: imgUrl! as URL)
            detailLargeImage.image = UIImage(data: data! as Data)
        }
    }
    
    // MARK: - Collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.count
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCell", for: indexPath) as! FeaturesCollectionViewCell
        
        cell.featureName.text = features[indexPath.row].getName()
        
        let imgUrl = NSURL(string: features[indexPath.row].getImage())
        
        if imgUrl != nil {
            let data = NSData(contentsOf: imgUrl! as URL)
            cell.featureImage.image = UIImage(data: data! as Data)
        }
        return cell
    }
    
    // MARK: - MapView
    func setCameraPosition() {
        
        let camera = GMSCameraPosition.camera(withLatitude: detailsOfHouse.getLatitude(), longitude: detailsOfHouse.getLongitude(), zoom: 16.0)
        mapView.camera = camera
        showMarker(position: camera.target)
    }
    
    func showMarker(position: CLLocationCoordinate2D) {
        
        let marker = GMSMarker()
        marker.appearAnimation = .pop
        marker.position = position
        marker.title = detailsOfHouse.getName()
        marker.snippet = ""
        marker.map = mapView
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFeatures" {
            
            if let indexPaths = detailCollectionView.indexPathsForSelectedItems {
                let destinationController = segue.destination as! FeatureViewController
                destinationController.features = features[indexPaths[0].row]
            }
        }
        
         if segue.identifier == "showMap" {
            
            let destinationController = segue.destination as! MapViewController
            destinationController.products = detailsOfHouse
        }
    }
}
