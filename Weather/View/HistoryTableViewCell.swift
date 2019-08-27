//
//  HistoryTableViewCell.swift
//  Weather
//
//  Created by Aleksandr Tsebrii on 8/26/19.
//  Copyright © 2019 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var moodImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    // MARK: - Properties
    
    var mood: MoodData?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if let mood = mood {
            moodImageView.image = UIImage(named: mood.moodImage ?? "")
            locationLabel.text = mood.locationString
            weatherImageView.image = UIImage(named: mood.weatherImage ?? "")
            temperatureLabel.text = mood.temperatureString
            uvIndexLabel.text = "UV Index: " + (mood.uvIndexString ?? "")
            pressureLabel.text = "Pressure: " + (mood.pressureString ?? "")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm MMM dd, yyyy"
            dateLabel.text = dateFormatter.string(from: mood.date!)
        }
        
    }
    
}
