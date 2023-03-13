//
//  MusicTVC.swift
//  MyMusicApp
//
//  Created by eun-ji on 2023/03/12.
//

import UIKit

class MusicTVC: UITableViewCell {
 
    @IBOutlet weak var trackName: UILabel!
    
    
    @IBOutlet weak var artistName: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
 
    @IBOutlet weak var musicImageView: UIImageView! 
       
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
