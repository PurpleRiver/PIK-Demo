import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet fileprivate weak var mapView: GMSMapView!
    var products: Product = Product()
    let iconImage = UIImageView()
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImage.image = UIImage(named: "pikIcon")
        iconImage.layer.cornerRadius = 25
        iconImage.layer.masksToBounds = true
        
        setCameraPosition()
        mapView.delegate = self
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
    
    // MARK: - MapView
    func setCameraPosition() {
        
        let camera = GMSCameraPosition.camera(withLatitude: products.getLatitude(), longitude: products.getLongitude(), zoom: 16.0)
        mapView.camera = camera
        showMarker(position: camera.target)
    }
    
    func showMarker(position: CLLocationCoordinate2D) {
        
        let marker = GMSMarker()
        marker.appearAnimation = .pop
        marker.position = position
//        marker.title = products.getName()
        
        marker.icon = iconImage.image
//        marker.snippet = ""
        marker.map = mapView
        
    }
  
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)!.first as! CustomInfoWindow
        
        customInfoWindow.name.text = products.getName()
        
        let imgUrl = NSURL(string: products.getImage())
        
        if imgUrl != nil {
            let data = NSData(contentsOf: imgUrl! as URL)
            customInfoWindow.thumbImage.image = UIImage(data: data! as Data)
        }
  //      customInfoWindow.thumbImage.image = UIImage(named: products.getImage())
        
        return customInfoWindow
    }
}
