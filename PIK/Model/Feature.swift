import Foundation
// class for present features of house. DetailVC
class Feature {
    
    private var name: String
    private var image: String
    private var description: String
    
    init(name: String, image: String, description: String) {
        self.name = name
        self.image = image
        self.description = description
    }
    
    convenience init() {
        self.init(name: "", image: "", description: "")
    }
    
    func getName() -> String {
        return name
    }
    
    func getImage() -> String {
        return image
    }
    
    func getDescription() -> String {
        return description
    }
}
