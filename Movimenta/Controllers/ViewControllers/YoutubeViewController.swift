//
//  YoutubeViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/24/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YoutubeViewController: UIViewController {

  static func instance() -> YoutubeViewController {
    return Storyboard.Root.instantiate(YoutubeViewController.self)
  }

  @IBOutlet weak var youtubePlayerView: YTPlayerView!

  private var videoId: String?

  func initialize(with youtubeVideoId: String) {
    self.videoId = youtubeVideoId
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    if let videoId = videoId {
      youtubePlayerView.load(withVideoId: videoId)
    }
  }
}
