//
//  ViewController.swift
//  VideoMaker
//
//  Created by Иван Свиридов on 18.12.2017.
//  Copyright © 2017 Иван Свиридов. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import MediaPlayer

class ViewController: UIViewController {
  
  //MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  //MARK: - Instance variables
  var videos: PHFetchResult<PHAsset>? {
    didSet {
      tableView.reloadData()
    }
  }
  var assetURL: URL?
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    videos = VideoManager.fetchVideosFromCameraRoll()
    
    tableView.delegate = self
    tableView.dataSource = self
  }

  @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
    var title = "Success"
    var message = "Video is saved"
    if let _ = error {
      title = "Error"
      message = "Video failed to save"
    }

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
      self.videos = VideoManager.fetchVideosFromCameraRoll() })
    present(alert, animated: true, completion: nil)
  }

  
  //MARK: - Actions
  @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
    if UIImagePickerController.isSourceTypeAvailable(.camera) && UIImagePickerController.availableCaptureModes(for: .rear) != nil {
      let picker = UIImagePickerController()
      picker.sourceType = .camera
      picker.cameraDevice = .rear
      picker.mediaTypes = [(UIImagePickerController.availableMediaTypes(for: picker.sourceType)?.last)!]
      picker.allowsEditing = false
      picker.delegate = self
      present(picker, animated: true, completion: nil)
    }
  }
  
  //MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destVC = segue.destination as? VideoViewController, segue.identifier == Segue.showVideo {
      destVC.assetURL = assetURL
    }
  }
  
}

extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return videos?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId, for: indexPath) as! TableViewCell
    
    if let asset = videos?[indexPath.row] {
      cell.videoName?.text = asset.localIdentifier
      cell.videoLength.text = String(format: "Duration: %02d:%02d",
                                     Int(asset.duration / 60), Int(asset.duration) % 60)
      
      PHImageManager.default().requestImage(for: asset,
                           targetSize: CGSize(width: cell.videoPreview.bounds.width,
                                              height: cell.videoPreview.bounds.height),
                           contentMode: .aspectFill,
                           options: nil) { image, _ in
                            cell.videoPreview?.image = image
      }
    }
    
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let asset = videos?[indexPath.row] else { return }
    
  }
  
}

extension ViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let mediaType = info[UIImagePickerControllerMediaType] as? String else { return }
    picker.dismiss(animated: true)
    
    if mediaType == UIImagePickerController.availableMediaTypes(for: picker.sourceType)?.last {
      guard let path = (info[UIImagePickerControllerMediaURL] as? URL)?.path else { return }
      
      if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
        UISaveVideoAtPathToSavedPhotosAlbum(path,
                                            self,
                                            #selector(video(_:didFinishSavingWithError:contextInfo:)),
                                            nil)
      }
    }
  }
}

extension ViewController: UINavigationControllerDelegate {}
