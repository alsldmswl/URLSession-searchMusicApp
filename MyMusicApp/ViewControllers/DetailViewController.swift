//
//  DetailViewController.swift
//  MyMusicApp
//
//  Created by eun-ji on 2023/03/13.
//

import UIKit
import AVKit

class DetailViewController: UIViewController {

    var musicResult: MusicResult?
    @IBOutlet weak var detailTrackName: UILabel! {
        didSet{
            detailTrackName.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        }
    }
    @IBOutlet weak var detailArtistName: UILabel!
    @IBOutlet weak var musicContainer: UIView!

    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    
    @IBOutlet weak var playButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTrackName.text = musicResult?.trackName
        detailArtistName.text = musicResult?.artistName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let hasURL = musicResult?.previewUrl{
            musicPlay(urlString: hasURL)
        }
    }
    
    func musicPlay(urlString: String) {
        if let hasUrl = URL(string: urlString) {
            let player = AVPlayer(url: hasUrl)
            let playerLayer = AVPlayerLayer(player: player)
            
            musicContainer.layer.addSublayer(playerLayer)
            playerLayer.frame = musicContainer.bounds
            player.play()
        }
    }
}
