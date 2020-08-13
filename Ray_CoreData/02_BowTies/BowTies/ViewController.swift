/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreData

class ViewController: UIViewController {
  
  var window: UIWindow?
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var timesWornLabel: UILabel!
  @IBOutlet weak var lastWornLabel: UILabel!
  @IBOutlet weak var favoriteLabel: UILabel!
  @IBOutlet weak var wearButton: UIButton!
  @IBOutlet weak var rateButton: UIButton!
  
  
  // MARK: - Properties
  
  var managedContext: NSManagedObjectContext!
  var currentBowTie: BowTie!
  
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    managedContext = appDelegate?.persistentContainer.viewContext
    
    //1. Insert Data from plist
    insertSampleData()
    
    //2. You create a fetch request for the purpose of fetching the newly inserted BowTie entities
    let request: NSFetchRequest<BowTie> = BowTie.fetchRequest()
    let firstTitle = segmentedControl.titleForSegment(at: 0)!
    request.predicate = NSPredicate(format: "%K = %@",
                                    argumentArray: [#keyPath(BowTie.searchKey), firstTitle])
    do {
      //3. As always, the managed object context does the heavy lifting for you. It executes the fetch request you crafted moments earlier and returns an array of BowTie objects
      let results = try managedContext.fetch(request)
      currentBowTie = results.first
      
      //4. You populate the user interface with the first bow tie in the results array. If there was an error, print the error to the console
      populate(bowtie: results.first!)
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
  
  
  // MARK: - IBActions
  
  @IBAction func segmentedControl(_ sender: UISegmentedControl) {
    
    guard let selectedValue = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
    
    let request: NSFetchRequest<BowTie> = BowTie.fetchRequest()
    request.predicate = NSPredicate(format: "%K = %@",
                                    argumentArray: [#keyPath(BowTie.searchKey), selectedValue])
    
    do {
      let results = try managedContext.fetch(request)
      currentBowTie = results.first
      populate(bowtie: currentBowTie)
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
  
  @IBAction func wear(_ sender: UIButton) {
    
    let times = currentBowTie.timesWorn
    currentBowTie.timesWorn = times + 1
    currentBowTie.lastWorn = Date()
    
    do {
      try managedContext.save()
      populate(bowtie: currentBowTie)
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
  
  @IBAction func rate(_ sender: UIButton) {
    
    let alert = UIAlertController(title: "New Rating",
                                  message: "Rate This bow tie",
                                  preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.keyboardType = .decimalPad
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
                                      if let textField = alert.textFields?.first {
                                        self.update(rating: textField.text)
                                      }
    }
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    
    present(alert, animated: true)
  }
  
  /// Load data from plist file
  func insertSampleData() {
    
    let fetch: NSFetchRequest<BowTie> = BowTie.fetchRequest()
    fetch.predicate = NSPredicate(format: "searchKey != nil")
    
    let count = try! managedContext.count(for: fetch)
    
    if count > 0 {
      // SampleData.plist data already in CoreData
      return
    }
    
    let path = Bundle.main.path(forResource: "SampleData",
                                ofType: "plist")
    let dataArray = NSArray(contentsOfFile: path!)!
    
    for dict in dataArray {
      let entity = NSEntityDescription.entity(forEntityName: "BowTie",
                                              in: managedContext)!
      let bowtie = BowTie(entity: entity,
                          insertInto: managedContext)
      let btDict = dict as! [String: Any]
      
      bowtie.id = UUID(uuidString: btDict["id"] as! String)
      bowtie.name = btDict["name"] as? String
      bowtie.searchKey =  btDict["searchKey"] as? String
      bowtie.rating = btDict["rating"] as! Double
      let colorDict = btDict["tintColor"] as! [String: Any]
      bowtie.tintColor = UIColor.color(dict: colorDict)
      
      let imageName = btDict["imageName"] as? String
      let image = UIImage(named: imageName!)
      bowtie.photoData = image?.pngData()
      bowtie.lastWorn = btDict["lastWorn"] as? Date
      
      let timesNumber = btDict["timesWorn"] as! NSNumber
      bowtie.timesWorn = timesNumber.int32Value
      bowtie.isFavorite = btDict["isFavorite"] as! Bool
      bowtie.url = URL(string: btDict["url"] as! String)
    }
    try! managedContext.save()
  }
  
  /// Update UI
  /// - Parameter bowtie: CoreData Entity
  func populate(bowtie: BowTie) {
    
    guard
      let imageData = bowtie.photoData as Data?,
      let lastWorn = bowtie.lastWorn as Date?,
      let tintColor = bowtie.tintColor as? UIColor else {
        return
    }
    
    imageView.image = UIImage(data: imageData)
    nameLabel.text = bowtie.name
    ratingLabel.text = "Rating: \(bowtie.rating)/5"
    
    timesWornLabel.text = "# times worn: \(bowtie.timesWorn)"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    
    lastWornLabel.text = "Last worn: " + dateFormatter.string(from: lastWorn)
    
    favoriteLabel.isHidden = !bowtie.isFavorite
    view.tintColor = tintColor
  }
  
  /// Update rating
  /// - Parameter rating: Rating
  func update(rating: String?) {
    
    guard let ratingString = rating,
      let rating = Double(ratingString) else { return }
    
    do {
      currentBowTie.rating = rating
      try managedContext.save()
      populate(bowtie: currentBowTie)
    } catch let error as NSError {
      //Check the max/min value error
      if error.domain == NSCocoaErrorDomain &&
        (error.code == NSValidationNumberTooLargeError ||
          error.code == NSValidationNumberTooSmallError) {
        rate(rateButton)
      } else {
        print("Could not save \(error), \(error.userInfo)") }
      }
  }
  
  
}//CLASS END


//MARK: - EXTENSION. UICOLOR

private extension UIColor {
  static func color(dict: [String : Any]) -> UIColor? {
    guard let red = dict["red"] as? NSNumber,
      let green = dict["green"] as? NSNumber,
      let blue = dict["blue"] as? NSNumber else {
        return nil
    }
    return UIColor(red: CGFloat(truncating: red) / 255.0,
                   green: CGFloat(truncating: green) / 255.0,
                   blue: CGFloat(truncating: blue) / 255.0,
                   alpha: 1)
  }
}
