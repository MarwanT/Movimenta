//
//  AugmentedViewController.swift
//  Movimenta
//
//  Created by Shafic Hariri on 9/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AugmentedViewController: UIViewController {

  static func instance() -> AugmentedViewController {
    return Storyboard.Root.instantiate(AugmentedViewController.self)
  }

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var arButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    hideNavigationBarShadow()
    
    //MARK: [Analytics] Screen Name
    Analytics.shared.send(screenName: Analytics.ScreenNames.AugmentedReality)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    showNavigationBarShadow()
  }

  private func initialize() {
    title = Strings.ar()
    
    applyTheme()
    setupView()
  }

  private func applyTheme() {
    let theme = ThemeManager.shared.current

    view.backgroundColor = theme.white

    //Fonts
    titleLabel.font = ThemeManager.shared.current.font1
    subtitleLabel.font = ThemeManager.shared.current.font3
    //Color
    titleLabel.textColor = ThemeManager.shared.current.lightTextColor
    subtitleLabel.textColor = ThemeManager.shared.current.lightTextColor

    theme.stylePrimaryButton(button: arButton)
  }

  private func setupView() {
    let theme = ThemeManager.shared.current
    titleLabel.paragraph(with: Strings.find_m(), lineHeight: theme.fontBook1.lineHeight)
    subtitleLabel.text = Strings.find_scan_message()
    arButton.setTitle(Strings.find_button(), for: .normal)

    arButton.addTarget(self, action: #selector(arButtonTouchUpInside(_:)), for: UIControlEvents.touchUpInside)
    
    navigationItem.backBarButtonItem = UIBarButtonItem.back
  }

  // MARK: Actions
  func arButtonTouchUpInside(_ sender: UIView) {
    checkCameraPermissions { (success) in
      if(success) {
        let arViewController = ARViewController()
        arViewController.targetDelegate = self
        arViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(arViewController, animated: true)
        
        //MARK: [Analytics] Event
        let analyticsEvent = Analytics.Event(category: .augmentedReality, action: .getStarted)
        Analytics.shared.send(event: analyticsEvent)
      }
    }
  }

  /**
   * Validate the permissions of the camera and
   * library, if the user do not accept these
   * permissions, it shows an view that notifies
   * the user that it not allow the permissions.
   */
  private func checkCameraPermissions(completionBlock: @escaping (_ success: Bool) -> ()) {
    let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
    if(deviceHasCamera) {
      let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)

      switch authStatus {
      case .authorized: completionBlock(true)
      case .denied: alertPromptToAllowCameraAccessViaSettings(completionBlock: completionBlock)
      case .notDetermined: permissionPrimeCameraAccess(completionBlock: completionBlock)
      default: permissionPrimeCameraAccess(completionBlock: completionBlock)
      }

    } else {
      hasNoCameraAlert(completionBlock: completionBlock)
    }
  }

  func hasNoCameraAlert(completionBlock: @escaping (_ success: Bool) -> ()) {
    let alertController = UIAlertController(title: Strings.device_has_no_camera_alert_title(), message: Strings.device_has_no_camera_alert_message(), preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: Strings.ok(), style: .default, handler: { (alert) in
      completionBlock(false)
    })
    alertController.addAction(defaultAction)

    present(alertController, animated: true, completion: nil)
  }

  func alertPromptToAllowCameraAccessViaSettings(completionBlock: @escaping (_ success: Bool) -> ()) {
    let alert = UIAlertController(title: Strings.allow_camera_access_via_settings_alert_title(), message: Strings.allow_camera_access_via_settings_alert_message(), preferredStyle: .alert )
    alert.addAction(UIAlertAction(title: Strings.allow_camera_access_via_settings_alert_button(), style: .cancel) { alert in
      completionBlock(false)
      UIApplication.openUrl(url: URL(string: UIApplicationOpenSettingsURLString)!)
    })
    present(alert, animated: true, completion: nil)
  }


  func permissionPrimeCameraAccess(completionBlock: @escaping (_ success: Bool) -> ()) {
    let alert = UIAlertController( title: Strings.allow_camera_access_via_settings_alert_title(), message: Strings.allow_camera_access_via_settings_alert_message(), preferredStyle: .alert )
    let allowAction = UIAlertAction(title: Strings.allow_camera_access_alert_button_yes(), style: .default, handler: { (alert) -> Void in
      AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { granted in
        DispatchQueue.main.async {
          completionBlock(true)
        }
      })
    })
    alert.addAction(allowAction)
    let declineAction = UIAlertAction(title: Strings.allow_camera_access_alert_button_no(), style: .cancel) { (alert) in
      completionBlock(false)
    }
    alert.addAction(declineAction)
    present(alert, animated: true, completion: nil)
  }
}

extension AugmentedViewController: ARViewControllerDelegate {
  func didLocateTarget(meta: String, name: String) {
    if(!meta.isEmpty) {
      let vc = YoutubeViewController.instance()
      vc.initialize(with: meta)
      vc.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(vc, animated: true)
      
      //MARK: [Analytics] Event
      let analyticsEvent = Analytics.Event(
        category: .augmentedReality, action: .scanImage, name: name)
      Analytics.shared.send(event: analyticsEvent)
    }
  }
}
