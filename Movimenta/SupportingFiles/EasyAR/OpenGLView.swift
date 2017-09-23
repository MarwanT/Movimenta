//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

import GLKit
import EasyARSwift


public class OpenGLView : GLKView {
  private var arManager: ARManager
  private var initialized: Bool = false

  override init(frame: CGRect) {
    arManager = ARManager()
    super.init(frame: frame)
    context = EAGLContext(api: EAGLRenderingAPI.openGLES2)!
    drawableColorFormat = GLKViewDrawableColorFormat.RGBA8888
    drawableDepthFormat = GLKViewDrawableDepthFormat.format24
    drawableStencilFormat = GLKViewDrawableStencilFormat.format8
    bindDrawable()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
  }

  public func start() {
    if arManager.initialize() {
      _ = arManager.start()
    }
  }

  public func stop() {
    _ = arManager.stop()
    arManager.dispose()
  }

  public func setDelegate(delegate: ARManagerDelegate?) {
    arManager.setDelegate(delegate: delegate)
  }

  public func resize(_ frame: CGRect, _ orientation: UIInterfaceOrientation) {
    var scale: CGFloat
    if #available(iOS 8, *) {
      scale = UIScreen.main.nativeScale
    } else {
      scale = UIScreen.main.scale
    }

    arManager.resizeGL(width: Int32(frame.size.width * scale), height: Int32(frame.size.height * scale))
  }

  public override func draw(_ rect: CGRect) {
    if !initialized {
      arManager.initGL()
      initialized = true
    }
    arManager.render()
  }

  public func setOrientation(_ orientation: UIInterfaceOrientation) {
    do {
      switch orientation {
      case .portrait:
        try Engine.setRotation(270)
      case .portraitUpsideDown:
        try Engine.setRotation(90)
      case .landscapeLeft:
        try Engine.setRotation(180)
      case .landscapeRight:
        try Engine.setRotation(0)
      default:
        break
      }
    } catch let error {
      print("error: \(error)")
    }
  }
}
