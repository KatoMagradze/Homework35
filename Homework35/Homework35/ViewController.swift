//
//  ViewController.swift
//  Homework35
//
//  Created by Kato on 6/5/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import SkeletonView

class ViewController: UIViewController, SkeletonTableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var colors = [Color]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.dataSource = self
        
        self.get()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .lightGray), animation: nil, transition: .crossDissolve(0.25))
    }
    
    func get() {
        let url = URL(string: "https://reqres.in/api/unknown")!
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let userColor = try decoder.decode(UserColor.self, from: data)
                
                self.colors.append(contentsOf: userColor.colors)
                
//                DispatchQueue.main.async {
//                    self.tableView.stopSkeletonAnimation()
//                    self.view.hideSkeleton()
//                    self.tableView.reloadData()
//                }
                
                
                //მონაცემების რაოდენობა არის ცოტა, ამიტომ asyncAfter დავუმატე რომ კარგად გამოჩნდეს shimmer ეფექტი
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.tableView.stopSkeletonAnimation()
                    self.view.hideSkeleton()
                    self.tableView.reloadData()
                }
                
            }
            catch {print(error.localizedDescription)}
            
        }.resume()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        
        return "colors_cell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "colors_cell", for: indexPath) as! ColorsCell
        
        let cellColor = hexStringToUIColor(hex: colors[indexPath.row].color)
        
        let img = UIImage.from(color: cellColor)
        
        cell.colorImage.image = img
        cell.nameLabel.text = colors[indexPath.row].name
        cell.hexLabel.text = colors[indexPath.row].color
        
        return cell
    }
    
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension ViewController {
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

struct UserColor: Codable {
    
    let colors: [Color]
    
    enum CodingKeys: String, CodingKey {
        case colors = "data"
    }
    
}

struct Color: Codable {
    let id: Int
    let name: String
    let year: Int
    let color: String
    let pantone: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case year
        case color
        case pantone = "pantone_value"
    }
}

