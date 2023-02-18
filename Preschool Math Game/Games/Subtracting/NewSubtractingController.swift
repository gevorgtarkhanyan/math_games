//
//  NewSubtractingController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 23.08.21.
//

import UIKit

class NewSubtractingController: BaseViewController {

    @IBOutlet weak var firstNum_1: UILabel!
    @IBOutlet weak var firstNum_2: UILabel!
    @IBOutlet weak var secondNum_1: UILabel!
    @IBOutlet weak var secondNum_2: UILabel!
    @IBOutlet weak var thirdNum_1: UILabel!
    @IBOutlet weak var thirdNum_2: UILabel!
    @IBOutlet weak var firstResultView: UIView!
    @IBOutlet weak var firstResultImage: UIImageView!
    @IBOutlet weak var firstResultLabel: UILabel!
    @IBOutlet weak var secondResultView: UIView!
    @IBOutlet weak var secondResultImage: UIImageView!
    @IBOutlet weak var secondResultLabel: UILabel!
    @IBOutlet weak var thirdResultView: UIView!
    @IBOutlet weak var thirdResultImage: UIImageView!
    @IBOutlet weak var thirdResultLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var firstLabelCollection: [UILabel]!
    @IBOutlet var secondLabelCollection: [UILabel]!
    @IBOutlet var thirdLabelCollection: [UILabel]!

    @IBOutlet weak var prizContainerView: UIImageView!
    @IBOutlet weak var prizImageView: UIImageView!

    var game: Game!

    static func initWithStoryboard() -> NewSubtractingController? {
        let storyboard = UIStoryboard(name: "SubtractingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: NewSubtractingController.name) as? NewSubtractingController
    }

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        //        AnalyticService.shared.setupAmplitude(game: "start_newSubtracting")

        setBorder()
        setFirstLabelsCount()
        setSecondLabelsCount()
        setThirdLabelsCount()
        setResultViewsCornerR()

        //        GamesLimit.newSubtractingPrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.newSubtractingPrizCount) as? Int ?? 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateNewSubtracting, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        do {
            guard let url = Bundle.main.url(forResource: "neuralnet-mnist-trained", withExtension: nil) else {
                fatalError("Unable to locate trained neural network file in bundle.")
            }
            neuralNet = try NeuralNet(url: url)
        } catch {
            fatalError("\(error)")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Functions
    private func setResultViewsCornerR() {
        let resultsArray = [firstResultView, secondResultView, thirdResultView]

        resultsArray.forEach({$0?.layer.cornerRadius = 5})
    }

    @objc func handleTap() {
        cleanCanvas()
    }

    private func cleanCanvas() {
        let resultsArray = [firstResultImage, secondResultImage, thirdResultImage]

        for image in resultsArray {
            self.clearCanvas(image: image!)
        }
    }

    @objc func update() {
        GamesLimit.newSubtractingLimit = 0
        updateMath()
    }

    private func updateMath() {
        setFirstLabelsCount()
        setSecondLabelsCount()
        setThirdLabelsCount()
        gamesCount = 0

        let resultsArray = [firstResultView, secondResultView, thirdResultView]
        resultsArray.forEach({$0?.isHidden = false})
    }

    private func setBorder() {
        containerView.layer.borderWidth = 5
        containerView.layer.borderColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
    }

    private func setFirstLabelsCount() {
        let firstRandomNumber = 0..<9
        let firstCount: Int = Random.getRandomIndex(in: firstRandomNumber)

        let secondRandomNumber = 0..<9
        firstCounts = Random.getRandomIndex(in: secondRandomNumber)

        if firstCount < firstCounts {
            setFirstLabelsCount()
        } else {
            firstNum_1.text = String(firstCount)
            firstNum_2.text = String(firstCounts)
            firstFinalCount = firstCount - firstCounts
        }
    }

    private func setSecondLabelsCount() {
        let firstRandomNumber = 0..<9
        let firstCount: Int = Random.getRandomIndex(in: firstRandomNumber)

        let secondRandomNumber = 0..<9
        secondCounts = Random.getRandomIndex(in: secondRandomNumber, ignore: firstCounts)
        
        if firstCount < secondCounts {
            setSecondLabelsCount()
        } else {
            secondNum_1.text = String(firstCount)
            secondNum_2.text = String(secondCounts)
            secondFinalCount = firstCount - secondCounts
        }
    }

    private func setThirdLabelsCount() {
        let firstRandomNumber = 0..<9
        let firstCount: Int = Random.getRandomIndex(in: firstRandomNumber)

        let secondRandomNumber = 0..<9
        thirdCounts = Random.getRandomIndex(in: secondRandomNumber, ignoredIndexes: [firstCounts, secondCounts])

        if firstCount < thirdCounts {
            setThirdLabelsCount()
        } else {
            thirdNum_1.text = String(firstCount)
            thirdNum_2.text = String(thirdCounts)
            thirdFinalCount = firstCount - thirdCounts
        }
    }

    // MARK: - Actions
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Touch in View
extension NewSubtractingController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        hasSwiped = false

        var setView = UIView()

        if touch.view == firstResultView {
            setView = firstResultView
            index = 0
        } else if touch.view == secondResultView {
            setView = secondResultView
            index = 1
        } else if touch.view == thirdResultView {
            setView = thirdResultView
            index = 2
        }

        guard view.frame.contains(touch.location(in: setView)) else { return super.touchesBegan(touches, with: event) }

        let location = touch.location(in: setView)

        if boundingBox == nil {
            boundingBox = CGRect(x: location.x - brushWidth / 2,
                                 y: location.y - brushWidth / 2,
                                 width: brushWidth, height: brushWidth)
        }

        lastDrawPoint = location

        isDrawing = true

        timer.invalidate()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        var setView = UIView()
        var img = UIImageView()

        if touch.view == firstResultView {
            setView = firstResultView
            img = firstResultImage
        } else if touch.view == secondResultView {
            setView = secondResultView
            img = secondResultImage
        } else if touch.view == thirdResultView {
            img = thirdResultImage
            setView = thirdResultView
        }

        guard view.frame.contains(touch.location(in: setView)) else {
            hasSwiped = false
            return super.touchesMoved(touches, with: event)
        }

        let currentPoint = touch.location(in: setView)

        if boundingBox == nil {
            boundingBox = CGRect(x: currentPoint.x - brushWidth,
                                 y: currentPoint.y - brushWidth,
                                 width: brushWidth, height: brushWidth)
        }

        if hasSwiped {
            drawLine(from: lastDrawPoint, to: currentPoint, view: setView, image: img)
        } else {
            drawLine(from: currentPoint, to: currentPoint, view: setView, image: img)
            hasSwiped = true
        }

        if currentPoint.x < boundingBox!.minX {
            stretchBoundingBox(minX: currentPoint.x - brushWidth,
                               maxX: nil, minY: nil, maxY: nil)
        } else if currentPoint.x > boundingBox!.maxX {
            stretchBoundingBox(minX: nil,
                               maxX: currentPoint.x + brushWidth,
                               minY: nil, maxY: nil)
        }

        if currentPoint.y < boundingBox!.minY {
            stretchBoundingBox(minX: nil, maxX: nil,
                               minY: currentPoint.y - brushWidth,
                               maxY: nil)
        } else if currentPoint.y > boundingBox!.maxY {
            stretchBoundingBox(minX: nil, maxX: nil, minY: nil,
                               maxY: currentPoint.y + brushWidth)
        }

        lastDrawPoint = currentPoint

        timer.invalidate()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        var setView = UIView()
        var img = UIImageView()

        if touch.view == firstResultView {
            setView = firstResultView
            img = firstResultImage
        } else if touch.view == secondResultView {
            setView = secondResultView
            img = secondResultImage
        } else if touch.view == thirdResultView {
            img = thirdResultImage
            setView = thirdResultView
        }

        if view.frame.contains(touch.location(in: setView)) {
            if !hasSwiped {
                drawLine(from: lastDrawPoint, to: lastDrawPoint, view: setView, image: img)
            }
        }

        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] (_) in
            self?.timerExpired(image: img)
        }

        isDrawing = false

        super.touchesEnded(touches, with: event)
    }
}

// MARK: Drawing and image manipulation
extension NewSubtractingController {

    private func drawLine(from: CGPoint, to: CGPoint, view: UIView, image: UIImageView) {
        UIGraphicsBeginImageContext(view.bounds.size)
        let context = UIGraphicsGetCurrentContext()

        image.image?.draw(in: view.bounds)

        context?.move(to: from)
        context?.addLine(to: to)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: 255, green: 255, blue: 255, alpha: 1)
        context?.strokePath()

        image.image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
    }

    private func crop(_ image: UIImage, to: CGRect) -> UIImage {
        let img = image.cgImage!.cropping(to: to)
        return UIImage(cgImage: img!)
    }

    private func scale(_ image: UIImage, to: CGSize) -> UIImage {
        let size = CGSize(width: min(20 * image.size.width / image.size.height, 20),
                          height: min(20 * image.size.height / image.size.width, 20))
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height).integral
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = .none
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    private func addBorder(to image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 28, height: 28))
        image.draw(at: CGPoint(x: (28 - image.size.width) / 2,
                               y: (28 - image.size.height) / 2))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    private func stretchBoundingBox(minX: CGFloat?, maxX: CGFloat?, minY: CGFloat?, maxY: CGFloat?) {
        guard let box = boundingBox else { return }
        boundingBox = CGRect(x: minX ?? box.minX,
                             y: minY ?? box.minY,
                             width: (maxX ?? box.maxX) - (minX ?? box.minX),
                             height: (maxY ?? box.maxY) - (minY ?? box.minY))
    }

    private func clearCanvas(image: UIImageView) {
        UIView.animate(withDuration: 0.1) {
            image.image = nil
            image.alpha = 1
        }
    }
}

// MARK: Classification
extension NewSubtractingController {

    private func timerExpired(image: UIImageView) {
        classifyImage(image: image)
        boundingBox = nil
    }

    private func classifyImage(image: UIImageView) {
        //        defer { clearCanvas(image: image) }

        guard let imageArray = scanImage(image: image) else { return }

        do {
            let output = try neuralNet.infer(imageArray)

            if let (label, _) = label(from: output) {
                let count = label.description
                
                if index == 0 && firstFinalCount == label {
                    firstResultLabel.text = String(count)
                    firstResultView.isHidden = true
                    gamesCount += 1
                } else if index == 1 && secondFinalCount == label {
                    secondResultLabel.text = String(count)
                    secondResultView.isHidden = true
                    gamesCount += 1
                } else if index == 2 && thirdFinalCount == label {
                    thirdResultLabel.text = String(count)
                    thirdResultView.isHidden = true
                    gamesCount += 1
                }

                if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.paymentKey) {
                    if GamesLimit.newSubtractingLimit < 5 {
                        if gamesCount == 3 {
                            GamesLimit.newSubtractingLimit += 1
                            UserDefaults.standard.setValue(GamesLimit.newSubtractingLimit, forKey: UserDefaultsKeys.newSubtractingLimit)
                            self.audio.playWinSound()

                            if GamesLimit.newSubtractingLimit != 5 {
                                timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { timer in
                                    self.updateMath()
                                }
                            } else {
                                //                                GamesLimit.newSubtractingPrizCount += 1
                                //                                UserDefaults.standard.setValue(GamesLimit.newSubtractingPrizCount, forKey: UserDefaultsKeys.newSubtractingPrizCount)
                                game.isLocked = true
                                self.prizContainerView.isHidden = false
                                self.prizImageView.isHidden = false
                                self.prizImageView.changeSizeImageWithAnimate()

                                timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                                    self.prizContainerView.isHidden = true
                                    self.prizImageView.isHidden = true
                                }

                                timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentalControllController") as! ParentalControllController

                                    vc.fromGame = true
                                    self.addChild(vc)
                                    self.view.addSubview(vc.view)
                                    vc.didMove(toParent: self)
                                }
                            }
                        }
                    }
                } else {
                    if GamesLimit.newSubtractingLimit == 5 {
                        if self.gamesCount == 3 {
                            GamesLimit.newSubtractingLimit = 0
                            UserDefaults.standard.setValue(GamesLimit.newSubtractingLimit, forKey: UserDefaultsKeys.newSubtractingLimit)
                            //                            GamesLimit.newDivisionPrizCount += 1
                            //                            UserDefaults.standard.setValue(GamesLimit.newSubtractingPrizCount, forKey: UserDefaultsKeys.newSubtractingPrizCount)

                            self.prizContainerView.isHidden = false
                            self.prizImageView.isHidden = false
                            self.prizImageView.changeSizeImageWithAnimate()
                            
                            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                                self.prizContainerView.isHidden = true
                                self.prizImageView.isHidden = true
                            }

                            timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                                self.audio.playWinSound()
                                self.updateMath()
                            }
                        }
                    } else {
                        if self.gamesCount == 3 {
                            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                                GamesLimit.newSubtractingLimit += 1
                                UserDefaults.standard.setValue(GamesLimit.newSubtractingLimit, forKey: UserDefaultsKeys.newSubtractingLimit)
                                self.audio.playWinSound()
                                self.updateMath()
                            }
                        }
                    }
                }
            }
        } catch {
            print(error)
        }

        cleanCanvas()
    }

    private func scanImage(image: UIImageView) -> [Float]? {
        var pixelsArray = [Float]()
        guard let image = image.image, let box = boundingBox else { return nil }

        let croppedImage = crop(image, to: box)
        
        let scaledImage = scale(croppedImage, to: CGSize(width: 20, height: 20))

        let character = addBorder(to: scaledImage)

        guard let cgImage = character.cgImage else { return nil }
        guard let pixelData = cgImage.dataProvider?.data else { return nil }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerRow = cgImage.bytesPerRow
        let bytesPerPixel = cgImage.bitsPerPixel / 8

        var position = 0
        for _ in 0..<Int(character.size.height) {
            for _ in 0..<Int(character.size.width) {
                if position + 3 < data.hashValue {
                    let alpha = Float(data[position + 3])
                    pixelsArray.append(alpha / 255)
                    position += bytesPerPixel
                }
            }
            if position % bytesPerRow != 0 {
                position += (bytesPerRow - (position % bytesPerRow))
            }
        }
        return pixelsArray
    }

    private func label(from output: [Float]) -> (label: Int, confidence: Float)? {
        guard let max = output.max() else { return nil }
        return (output.firstIndex(of: max)!, max)
    }
}
