import UIKit
import BonMot
import Alamofire

class MainTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var topGradientMask: UIImageView! {
        didSet {
            topGradientMask.setGradientBackground(colorOne: UIColor.black, colorTwo: UIColor.clear)
            topGradientMask.alpha = 0.5
        }
    }
    @IBOutlet weak var bottomGradientMask: UIImageView! {
        didSet {
            bottomGradientMask.setGradientBackground(colorOne: UIColor.clear, colorTwo: UIColor.black)
            bottomGradientMask.alpha = 1
        }
    }
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
            let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
            placeholderLabel?.font = UIFont.appFont(ofSize: 12)
        }
    }
    
    private var searchController: UISearchController!
    var searchResults: [Product] = []
    
    fileprivate var products = [Product]()
    
    @IBAction func callButtonIsPressed(_ sender: UIButton) {
        callInFeature()
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar for childViewController
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Implementing searchBar
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    private func filterContext(for searchText: String) {
        
        searchResults = products.filter({(product) -> Bool in
            print(product)
            let isMatch = product.getName().range(of: searchText, options: .caseInsensitive) != nil
            print(isMatch)
            return isMatch
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContext(for: searchText)
        }
    }
    
    // MARK: - Fetching data for collection view.
    
   private func fetchData() {
        Alamofire.request("https://my-json-server.typicode.com/PurpleRiver/fakeJsonServer/products").responseJSON { response in
            switch response.result {
            case .success:
                guard let string = String(data: response.data!, encoding: .utf8) else { return }
                print(string)
                
                guard let arrayOfProducts = response.result.value as? [[String:AnyObject]]
                    else {
                        print("Cant make an array")
                        return
                }
                
                for house in arrayOfProducts {
                    
                    let house = Product(name: house["name"] as! String, price: house["price"] as! String, image: house["image"] as! String, latitude: house["latitude"] as! Double, longitude: house["longitude"] as! Double)
                    
                    self.products.append(house)
                }
                
            case .failure(let error):
                print(error)
            }
            // Get back to the main thread
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
            
        } else {
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
        
        let product = (searchController.isActive) ? searchResults[indexPath.row] : products[indexPath.row]
        
        cell.productNameLabel.text = product.getName()
        cell.productPriceLabel.text = product.getPrice()
        
        let imgUrl = NSURL(string: product.getImage())
        
        if imgUrl != nil {
            let data = NSData(contentsOf: imgUrl! as URL)
            cell.productImage.image = UIImage(data: data! as Data)
        }
        return cell
    }
    
     // Functionality for call button
    func callInFeature() {
        
        let callOptionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let callToOffice = UIAlertAction(title: "Позвонить в ПИК", style: .default) { (action:UIAlertAction!) -> Void in
            
            let alertMessage = UIAlertController(title: "+7(495)116-77-52", message: nil, preferredStyle: .alert)
            
            alertMessage.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            alertMessage.addAction(UIAlertAction(title: "Позвонить", style: .default, handler: nil))
            
            self.present(alertMessage, animated: true)
        }
        
        let orderCallback = UIAlertAction(title: "Заказать обратный звонок", style: .default) { (action:UIAlertAction!) -> Void in
            
            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Pealse retry later.", preferredStyle: .alert)
            
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertMessage, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        callOptionsMenu.addAction(callToOffice)
        callOptionsMenu.addAction(orderCallback)
        callOptionsMenu.addAction(cancelAction)
        
        present(callOptionsMenu, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewControllerForFiltering" {
            if segue.destination is FilterTableViewController {
            }
        }
        
        if segue.identifier == "detailViewController" {
            
            if let indexPaths = collectionView.indexPathsForSelectedItems {
                let destinationController = segue.destination as! DetailTableViewController
                destinationController.detailsOfHouse = products[indexPaths[0].row]
            }
        }
    }
}

