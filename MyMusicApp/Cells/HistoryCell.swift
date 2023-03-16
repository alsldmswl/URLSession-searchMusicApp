//
//  HistoryCell.swift
//  MyMusicApp
//
//  Created by eun-ji on 2023/03/13.
//

import UIKit

protocol MyTableViewCellDelegate: AnyObject {
    func didTapButton(with idx: Int)
}

class HistoryCell: UITableViewCell {

    
    @IBOutlet weak var termLabel: UILabel!
    
    
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: MyTableViewCellDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private var removeIdx: Int = 99999
    
    func configure(with idx: Int) {
        removeIdx = idx
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        delegate?.didTapButton(with: removeIdx)
    }

}
