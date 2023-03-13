//
//  DetailViewController.swift
//  MyMusicApp
//
//  Created by eun-ji on 2023/03/13.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {

    var musicResult: MusicResult?
    var musicPlayer = AVPlayer()
    var timeObserver: Any?
    var isSeeking: Bool = false
    
    @IBOutlet weak var detailTrackName: UILabel! {
        didSet{
            detailTrackName.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        }
    }
    @IBOutlet weak var detailArtistName: UILabel!
    @IBOutlet weak var musicContainer: UIView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var musicSlider: UISlider!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTrackName.text = musicResult?.trackName
        detailArtistName.text = musicResult?.artistName
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
        playButton.setImage(image, for: .normal)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let hasURL = musicResult?.previewUrl{
            musicPlay(urlString: hasURL)
        }
        updateTime(time: CMTime.zero)
        timeObserver = self.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main) { time in
            self.updateTime(time: time)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        musicPlayer.pause()
    }
    
    
    @IBAction func togglePlayButton(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            let configuration = UIImage.SymbolConfiguration(pointSize: 30)
            let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playButton.setImage(image, for: .normal)
        } else {
            musicPlayer.play()
            let configuration = UIImage.SymbolConfiguration(pointSize: 30)
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playButton.setImage(image, for: .normal)
        }
    }
    
    @IBAction func seek(_ sender: UISlider) {
        guard let currentItem =  musicPlayer.currentItem else { return }
        let position = Double(sender.value)
        let seconds = currentItem.duration.seconds * position
        let time = CMTime(seconds: seconds, preferredTimescale: 100)
        musicPlayer.seek(to: time)
    }
    
    @IBAction func endDrag(_ sender: UISlider) {
        isSeeking = false
    }
    
    @IBAction func beginDrag(_ sender: UISlider) {
        isSeeking = true
    }
    
  
    @IBAction func toggleFavoriteButton(_ sender: Any) {
        favoriteButton.isSelected = !favoriteButton.isSelected
    }
    
    
    func musicPlay(urlString: String) {
        if let hasUrl = URL(string: urlString) {
            musicPlayer = AVPlayer(url: hasUrl)
            let playerLayer = AVPlayerLayer(player: musicPlayer)

            musicContainer.layer.addSublayer(playerLayer)
            playerLayer.frame = musicContainer.bounds
            musicPlayer.play()
        }
    }
    
    var currentTime: Double {
        return musicPlayer.currentItem?.currentTime().seconds ?? 0
    }
    
    var totalDurationTime: Double {
        return musicPlayer.currentItem?.duration.seconds ?? 0
    }
  
    var isPlaying: Bool {
        return musicPlayer.isPlaying
    }
    
    var currentItem: AVPlayerItem? {
        return musicPlayer.currentItem
    }
    
    func seek(to time: CMTime) {
        musicPlayer.seek(to: time)
    }
    func replaceCurrentItem(with item: AVPlayerItem?) {
        musicPlayer.replaceCurrentItem(with: item)
    }
    
    func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) {
        musicPlayer.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
    }
}

extension AVPlayer {
    var isPlaying: Bool{
        guard self.currentItem != nil else {return false}
        return self.rate != 0
    }
}

extension DetailViewController {

    func updateTime(time: CMTime) {
        currentTimeLabel.text = secondsToString(sec: self.currentTime)
        totalDurationLabel.text = secondsToString(sec: self.totalDurationTime)
        
        if isSeeking == false {
            musicSlider.value = Float(self.currentTime/self.totalDurationTime)
        }
    }
    
    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }

}
