//
//  MusicModel.swift
//  MyMusicApp
//
//  Created by eun-ji on 2023/03/12.
//

import Foundation

// MARK: - Welcome
struct MusicModel: Codable {
    let resultCount: Int
    let results: [MusicResult]
}

// MARK: - Result
struct MusicResult: Codable {
    let artistName, trackName: String?
    let previewUrl: String?
    let artworkUrl100: String?
    let releaseDate: String?
}
