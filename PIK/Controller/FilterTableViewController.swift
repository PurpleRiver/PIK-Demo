import UIKit
import MARKRangeSlider

class FilterTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // TO-DO animate constraints for slidein PickerView
    @IBAction func cityButtonIsPressed(_ sender: UIButton) {
        chooseCityPickerView.isHidden = false
    }
    @IBOutlet weak var chooseCityPickerView: UIPickerView!
    @IBOutlet weak var cityNamesLabel: UILabel!
    
    @IBAction func periodButtonIsPressed(_ sender: UIButton) {
        choosePeriodPickerView.isHidden = false
    }
    @IBOutlet weak var choosePeriodPickerView: UIPickerView!
    @IBOutlet weak var choosePeriodLabel: UILabel!
    
    @IBOutlet var rangeSlider: MARKRangeSlider! {
        didSet {
            rangeSlider.rangeImage = UIImage(named: "rangeImage")
        }
    }
    @IBOutlet weak var minimumValueLabel: UILabel!
    @IBOutlet weak var maximumValueLabel: UILabel!
    
    
    // Hardcoded variables
    private let cityNames = ["Москва и область", "Санкт-Петербург", "Екатеренбург", "Тюмень", "Ростов-на-Дону", "Обнинск", "Калуга", "Новороссийск", "Ярославль", "Пермь"]
    
    private let differentPeriods = ["Идет заселение", "Я подожду", "1 квартал 2019", "2 квартал 2019", "3 квартал 2019", "4 квартал 2019", "1 квартал 2020"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choosePeriodPickerView.dataSource = self
        choosePeriodPickerView.delegate = self
        chooseCityPickerView.dataSource = self
        chooseCityPickerView.delegate = self
        
        tableView.tableFooterView = UIView(frame: .zero)
        setupSlider()
    }
    
    // MARK: - Implementation of Range Slider
    
    private func setupSlider() {
        
        rangeSlider = MARKRangeSlider.init(frame: CGRect.zero)
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueDidChange), for: UIControl.Event.valueChanged)
        
        rangeSlider.setMinValue(1.9, maxValue: 18)
        rangeSlider.setLeftValue(1.9, rightValue: 18)
        rangeSlider.minimumDistance = 1
        
        rangeSlider.frame = CGRect(x: 20, y: 130, width: view.bounds.width - 40, height: 30)
        tableView.addSubview(rangeSlider)
    }
    
    @objc func rangeSliderValueDidChange(slider: MARKRangeSlider) {
        
        minimumValueLabel.text = ("от " + (NSString(format:"%.1f", slider.leftValue) as String) + " млн ₽")
        maximumValueLabel.text = ("до " + (NSString(format:"%.1f", slider.rightValue) as String) + " млн ₽")
    }
    
    // MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let numbersOfComponets = pickerView.tag == 1 ? cityNames.count : differentPeriods.count
        
        return numbersOfComponets
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let titlesForRow = pickerView.tag == 1 ? cityNames[row] : differentPeriods[row]
        
        return titlesForRow
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            cityNamesLabel.text = cityNames[row]
            
        } else {
            choosePeriodLabel.text = differentPeriods[row]
        }
    }
    // MARK: - TO DO Filter and animate results
}
