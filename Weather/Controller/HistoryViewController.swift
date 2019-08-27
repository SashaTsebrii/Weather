//
//  HistoryViewController.swift
//  Weather
//
//  Created by Aleksandr Tsebrii on 8/26/19.
//  Copyright © 2019 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var moods: [MoodData]?
    let cellIdentifier = Constants.CellIdentifier.historyTableViewCell
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        // TODO:
        //        let hour = 8
        
        var colorTop =  UIColor.white.cgColor
        var colorBottom = UIColor.white.cgColor
        
        if hour >= 0 && hour < 4 {
            // evening
            colorTop = UIColor.DesignColor.Background.Evening.Up.cgColor
            colorBottom = UIColor.DesignColor.Background.Evening.Down.cgColor
        } else if hour >= 4 && hour < 10 {
            // morning
            colorTop = UIColor.DesignColor.Background.Morning.Up.cgColor
            colorBottom = UIColor.DesignColor.Background.Morning.Down.cgColor
        } else if hour >= 10 && hour < 18 {
            // afternoon
            colorTop = UIColor.DesignColor.Background.Afternoon.Up.cgColor
            colorBottom = UIColor.DesignColor.Background.Afternoon.Down.cgColor
        } else if hour >= 18 {
            // evening
            colorTop = UIColor.DesignColor.Background.Evening.Up.cgColor
            colorBottom = UIColor.DesignColor.Background.Evening.Down.cgColor
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        do {
            let moods = try context.fetch(MoodData.fetchRequest()) as! [MoodData]
            // Sorted moods by date.
            let sortedMoods = moods.sorted(by: {
                $0.date!.compare($1.date!) == .orderedDescending
            })
            self.moods = sortedMoods
            self.tableView.reloadData()
        }
        catch {
            print("Fetching failed")
        }
        
    }

}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if moods != nil {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let moods = moods {
            return moods.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        
        cell.moodImageView.image = nil
        if let moods = moods {
            let mood = moods[indexPath.row]
            cell.mood = mood
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
