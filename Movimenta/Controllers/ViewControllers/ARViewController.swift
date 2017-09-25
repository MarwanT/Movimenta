//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

import GLKit

public class ARViewController: GLKViewController {
  private var glView: OpenGLView? = nil

  override public func loadView() {
    glView = OpenGLView(frame: CGRect.zero)
    view = glView
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    glView?.setOrientation(UIApplication.shared.statusBarOrientation)
    glView?.setDelegate(delegate: self)
  }

  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    glView?.start()
  }

  override public func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    glView?.stop()
  }

  override public func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    glView?.resize(self.view.bounds, UIApplication.shared.statusBarOrientation)
  }

  public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    coordinator.animate(alongsideTransition: { (_) in
      let orient = UIApplication.shared.statusBarOrientation
      self.glView?.setOrientation(orient)
    }, completion: nil)
    super.viewWillTransition(to: size, with: coordinator)
  }
}

extension ARViewController: ARManagerDelegate {
  public func didLocateTarget(meta: String) {
    if(!meta.isEmpty) {
      let vc = YoutubeViewController.instance()
      vc.initialize(with: meta)
    }
  }
}
