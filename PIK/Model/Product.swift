import Foundation

class Product {
    private var name = ""
    private var price = ""
    private var image = ""
    private var textAboutNeighborhood: String?
    private var latitude: Double
    private var longitude: Double
    
    init(name: String, price: String, image: String, textAboutNeighborhood: String, latitude: Double, longitude: Double) {
        self.name = name
        self.price = price
        self.image = image
        self.textAboutNeighborhood = textAboutNeighborhood
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init() {
        self.init(name: "", price: "", image: "", textAboutNeighborhood: "", latitude: 0, longitude: 0)
    }
    
    //Getters
    func getName() -> String {
        return name
    }
    
    func getPrice() -> String {
        return price
    }
    
    func getImage() -> String {
        return image
    }
    
    func getTextAboutNeighborhood() -> String? {
        return textAboutNeighborhood
    }
    
    func getLatitude() -> Double {
        return latitude
    }
    
    func getLongitude() -> Double {
        return longitude
    }
}


