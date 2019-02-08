import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    var products: Product = Product()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCameraPosition()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        customNavigationContoller()
    }
    
    // MARK: - Custom style for ViewController
    
    private func customNavigationContoller() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - MapView
    
    private func setCameraPosition() {
        
        let camera = GMSCameraPosition.camera(withLatitude: products.getLatitude(), longitude: products.getLongitude(), zoom: 16.0)
        
        mapView.camera = camera
        showMarker(position: camera.target)
    }
    
    private func showMarker(position: CLLocationCoordinate2D) {
        
        let marker = GMSMarker()
        marker.appearAnimation = .pop
        marker.position = position
        marker.icon = UIImage(named: "pikIcon")
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
        
        return customInfoWindow
    }
}
