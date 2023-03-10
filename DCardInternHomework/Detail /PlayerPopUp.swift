//
//  PlayerPopUp.swift
//  DCardInternHomework
//
//  Created by 楊宜濱 on 2023/3/9.
//

import Foundation
import UIKit
import AVFoundation
class PlayerPopUp:UIViewController {
    var detail:LookUpModel!
    private var isPlaying = true { // 控制是否播放中
        didSet {
            let img = ( isPlaying ) ? UIImage(named: "pause") : UIImage(named: "playerLogo")
            startBtn.setImage(img, for: .normal)
        }
    }
    
    private var timerObserve:Any? // 監聽歌曲 每秒更動 slider與timer ,  這要拉出來是因為 離開頁面時要設為 nil 避免 memory leak
    
    private var player:AVPlayer? // 播放器
    private var contentView = UIView()
    private var slider = UISlider() // 進度條
    private let songNameLabel = UILabel.createLabel(size: 22 * Theme.factor, color: .black)
    private let timerLabel = UILabel.createLabel(size: 18 * Theme.factor, color: UIColor(hex:0xD0D0D0)) // timer label
    private let startBtn = UIButton() // 播放按鈕
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(playIsFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timerObserve != nil {
            player?.removeTimeObserver(timerObserve!)
            timerObserve = nil
        }
        
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        layout()
        
        player?.play()
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(close))
        self.view.addGestureRecognizer(tapG)
        isPlaying = true
    }
    
    private func setUp() {
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        songNameLabel.text = detail.trackName // 設定歌名
        slider.addTarget(self, action: #selector(changeCurrentTime), for: .valueChanged) // 加入 slider 拖移監聽
        
        let url = URL(string:detail.previewUrl)
        player = AVPlayer(url:url!) // 建立播放器
        
        updatePlayerUI() // 根據跟取時間 計算slider value
        
        // 計時器 每秒 更動 1  ps:需要在退出時 remove 避免 memory leak
        self.timerObserve = player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (CMTime)  in
            guard let player = self.player else { return }
            if player.currentItem?.status == .readyToPlay { // 每秒更動 timerLabel 與slider 數值
                let currentTime = CMTimeGetSeconds(player.currentTime())
                self.slider.value = Float(currentTime)
                self.timerLabel.text = self.formatConversion(time: currentTime)
            }
        }) as Any
        
        startBtn.layer.cornerRadius = 15
        startBtn.addTarget(self, action: #selector(playerAction), for: .touchUpInside) // 監聽 播放按鈕 點擊事件
    }
    
    private func updatePlayerUI() { // 根據歌曲 設定 slider
        // 抓取 playItem 的 duration
        guard let playerItem = player?.currentItem else { return }
        let duration = playerItem.asset.duration
        let seconds = CMTimeGetSeconds(duration) // get Second
        slider.minimumValue = 0 // 最小值
        slider.maximumValue = Float(seconds) // 將秒數設為最大值
        slider.isContinuous = true // 拖移 更新狀態
    }
    
    private func formatConversion(time:Float64) -> String { // 時間轉換
        let songLength = Int(time)
        let minutes = Int(songLength / 60)
        let seconds = Int(songLength % 60)
        return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
    }
    
    
    private func layout() {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 550 * Theme.factor , height: 150 * Theme.factor))
        contentView.backgroundColor = .white
        contentView.center = CGPoint(x: UIScreen.main.bounds.width/2, y:  UIScreen.main.bounds.height/2)
        contentView.layer.cornerRadius = 15
        contentView.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
        self.view.addSubview(contentView)
        
        
        contentView.addSubviews(songNameLabel,startBtn,slider,timerLabel)
       
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            songNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            songNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 30 * Theme.factor),
            songNameLabel.heightAnchor.constraint(equalToConstant: 40 * Theme.factor),
            
            startBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10 * Theme.factor),
            startBtn.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor,constant: 10 * Theme.factor),
            startBtn.widthAnchor.constraint(equalToConstant: 60 * Theme.factor),
            startBtn.heightAnchor.constraint(equalToConstant: 60 * Theme.factor),
            
            slider.heightAnchor.constraint(equalToConstant: 40 * Theme.factor),
            slider.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            slider.centerYAnchor.constraint(equalTo: startBtn.centerYAnchor),
            slider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            timerLabel.centerYAnchor.constraint(equalTo: startBtn.centerYAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: slider.trailingAnchor,constant: 15 * Theme.factor),
            timerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10 * Theme.factor),
            timerLabel.heightAnchor.constraint(equalTo: startBtn.heightAnchor)
        ])
    }
}

extension PlayerPopUp {
    @objc private func playerAction() { // 點擊播放按鈕事件
        isPlaying = !isPlaying
        if ( isPlaying ) {
            player?.play()
        }
        else {
            player?.pause()
        }
    }
    
    @objc private func close() { // 關閉視窗 (點擊任意位置觸發)
        player?.pause()
        dismiss(animated: true)
    }
    
    @objc private func playIsFinish() { // 播放結束
        isPlaying = false
        player?.pause()
        
        let seconds = Int64(slider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        timerLabel.text = formatConversion(time: targetTime.seconds)
    }
    
    
    @objc private func changeCurrentTime() { // 拖移 slider 事件
        let seconds = Int64(slider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        // 將當前設置時間設為播放時間
        player?.seek(to: targetTime)
        timerLabel.text = formatConversion(time: targetTime.seconds)
    }
}
