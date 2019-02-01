import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet fileprivate weak var mapView: GMSMapView!
    var products: Product = Product()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
        marker.title = products.getName()
        marker.snippet = ""
        marker.map = mapView
    }
}
