import AppKit

// Target Dimensions for high-DPI rasterization
let W: CGFloat = 2048
let H: CGFloat = 2048
let canvas = NSImage(size: NSSize(width: W, height: H))
canvas.lockFocus()
guard let context = NSGraphicsContext.current?.cgContext else { fatalError("Graphics context unavailable") }

// Master Theme Colors
let darkTheme1 = NSColor(calibratedRed: 0.040, green: 0.065, blue: 0.120, alpha: 1.0)
let darkTheme2 = NSColor(calibratedRed: 0.065, green: 0.100, blue: 0.180, alpha: 1.0)
let cardFill = NSColor(calibratedRed: 0.085, green: 0.130, blue: 0.225, alpha: 0.95)
let cardStroke = NSColor(calibratedRed: 0.180, green: 0.250, blue: 0.380, alpha: 0.6)

let primaryText = NSColor(calibratedRed: 0.98, green: 0.98, blue: 1.0, alpha: 1.0)
let secondaryText = NSColor(calibratedRed: 0.65, green: 0.73, blue: 0.83, alpha: 1.0)
let tertiaryText = NSColor(calibratedRed: 0.48, green: 0.56, blue: 0.68, alpha: 1.0)
let goldAccent = NSColor(calibratedRed: 0.98, green: 0.72, blue: 0.20, alpha: 1.0)
let mintTeal = NSColor(calibratedRed: 0.18, green: 0.83, blue: 0.75, alpha: 1.0)
let alertRed = NSColor(calibratedRed: 0.97, green: 0.42, blue: 0.42, alpha: 1.0)
let techGreen = NSColor(calibratedRed: 0.20, green: 0.83, blue: 0.60, alpha: 1.0)
let defenseOrange = NSColor(calibratedRed: 0.98, green: 0.58, blue: 0.24, alpha: 1.0)
let tradeBlue = NSColor(calibratedRed: 0.25, green: 0.68, blue: 0.98, alpha: 1.0)
let culturePurple = NSColor(calibratedRed: 0.75, green: 0.52, blue: 0.98, alpha: 1.0)

func drawRect(_ x: CGFloat, _ yTop: CGFloat, _ w: CGFloat, _ h: CGFloat, _ c: NSColor) {
    c.setFill()
    NSRect(x: x, y: H - yTop - h, width: w, height: h).fill()
}

func drawRoundRect(_ x: CGFloat, _ yTop: CGFloat, _ w: CGFloat, _ h: CGFloat, _ r: CGFloat, _ fill: NSColor, _ stroke: NSColor? = nil, _ strokeW: CGFloat = 1) {
    let path = NSBezierPath(roundedRect: NSRect(x: x, y: H - yTop - h, width: w, height: h), xRadius: r, yRadius: r)
    fill.setFill()
    path.fill()
    if let stroke = stroke {
        stroke.setStroke()
        path.lineWidth = strokeW
        path.stroke()
    }
}

func drawLine(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ c: NSColor, _ w: CGFloat = 2) {
    c.setStroke()
    let p = NSBezierPath()
    p.move(to: NSPoint(x: x1, y: H - y1))
    p.line(to: NSPoint(x: x2, y: H - y2))
    p.lineWidth = w
    p.stroke()
}

func drawCircle(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ fill: NSColor, _ stroke: NSColor? = nil, _ strokeW: CGFloat = 2) {
    let p = NSBezierPath(ovalIn: NSRect(x: cx - r, y: H - cy - r, width: 2 * r, height: 2 * r))
    fill.setFill()
    p.fill()
    if let stroke = stroke {
        stroke.setStroke()
        p.lineWidth = strokeW
        p.stroke()
    }
}

func drawPoly(_ pts: [(CGFloat, CGFloat)], _ fill: NSColor, _ stroke: NSColor? = nil, _ strokeW: CGFloat = 1) {
    guard pts.count > 1 else { return }
    let p = NSBezierPath()
    p.move(to: NSPoint(x: pts[0].0, y: H - pts[0].1))
    for pt in pts.dropFirst() { p.line(to: NSPoint(x: pt.0, y: H - pt.1)) }
    p.close()
    fill.setFill()
    p.fill()
    if let stroke = stroke {
        stroke.setStroke()
        p.lineWidth = strokeW
        p.stroke()
    }
}

func renderText(_ s: String, _ x: CGFloat, _ yTop: CGFloat, _ w: CGFloat, _ h: CGFloat,
                _ size: CGFloat, _ weight: NSFont.Weight, _ c: NSColor, _ align: NSTextAlignment = .left, _ spacing: CGFloat = 3) {
    let font = NSFont.systemFont(ofSize: size, weight: weight)
    let para = NSMutableParagraphStyle()
    para.alignment = align
    para.lineBreakMode = .byWordWrapping
    para.lineSpacing = spacing
    let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: c, .paragraphStyle: para]
    NSString(string: s).draw(in: NSRect(x: x, y: H - yTop - h, width: w, height: h), withAttributes: attrs)
}

// Draw Background Gradient
NSGradient(starting: darkTheme1, ending: darkTheme2)?.draw(in: NSRect(x: 0, y: 0, width: W, height: H), angle: -45)

// Technical Gridlines
for x in stride(from: CGFloat(0), through: W, by: 64) { drawLine(x, 0, x, H, NSColor(white: 1, alpha: 0.015), 1) }
for y in stride(from: CGFloat(0), through: H, by: 64) { drawLine(0, y, W, y, NSColor(white: 1, alpha: 0.015), 1) }

// Top Gold Ribbon
drawRect(0, 0, W, 18, goldAccent)

// Masthead
renderText("THE GLOBAL DISPATCH  •  WORLD NEWS INTELLIGENCE", 80, 48, 1200, 36, 26, .bold, goldAccent)
renderText("DAILY EDITION #428", W - 480, 48, 400, 36, 24, .medium, tertiaryText, .right)

renderText("MONDAY, 23 NOVEMBER 2026", 76, 88, 1888, 100, 84, .black, primaryText)
renderText("A COMPREHENSIVE VISUAL SUMMARY OF TODAY'S TOP GLOBAL EVENTS IN ONE IMAGE", 80, 194, 1888, 36, 26, .medium, secondaryText)

// Key Datelines
drawRoundRect(80, 242, 1888, 52, 10, NSColor(calibratedRed: 0.06, green: 0.09, blue: 0.16, alpha: 0.9), cardStroke, 1.5)
let datelines = "ANTALYA (COP31)  •  WASHINGTON (WHITE HOUSE)  •  SANTA CLARA (NVIDIA)  •  BENGHAZI (NAVAL STRIKE)  •  BRUSSELS (EU PACT)  •  JAKARTA"
renderText(datelines, 100, 256, 1848, 28, 21, .bold, tertiaryText, .center)

drawLine(80, 314, W - 80, 314, NSColor(white: 1, alpha: 0.12), 2)

// News Story Matrix
let cardW: CGFloat = 598
let cardH: CGFloat = 780
let colXs: [CGFloat] = [80, 725, 1370]
let rowYs: [CGFloat] = [336, 1144]

struct NewsPanel {
    let col: Int
    let row: Int
    let tag: String
    let accent: NSColor
    let headline: String
    let subtitle: String
    let points: [String]
    let statNum: String
    let statTxt: String
    let graphicId: Int
}

let panels: [NewsPanel] = [
    NewsPanel(
        col: 0, row: 0,
        tag: "CLIMATE & ENVIRONMENT",
        accent: mintTeal,
        headline: "COP31 CLIMATE SUMMIT\nCOLLAPSES IN ANTALYA",
        subtitle: "190+ Nations Fail to Reach Cover Pact as Fossil Deadlock Persists",
        points: [
            "Antalya conference ends in bitter deadlock after 48h of overtime",
            "Divisions over binding fossil-fuel phase-out language sink agreement",
            "UN Secretary-General António Guterres calls outcome 'deeply disappointing'",
            "Voluntary 150-nation '35x35' clean power delivery framework salvaged"
        ],
        statNum: "190+",
        statTxt: "NATIONS DEADLOCKED",
        graphicId: 0
    ),
    NewsPanel(
        col: 1, row: 0,
        tag: "GEOPOLITICS & SECURITY",
        accent: alertRed,
        headline: "TRUMP WARNS OF NEW YEAR\nSTRIKES AGAINST IRAN",
        subtitle: "Military Strikes Signaled if Diplomatic Negotiations Fail",
        points: [
            "U.S. President warns of potential military action after New Year",
            "Ongoing naval blockade heavily chokes Iranian crude exports & revenue",
            "Widespread domestic truck driver fuel strikes spread across provinces",
            "West Bank settler violence sparks sharp global security condemnation"
        ],
        statNum: "JAN 2027",
        statTxt: "STRIKE DEADLINE SIGNALED",
        graphicId: 1
    ),
    NewsPanel(
        col: 2, row: 0,
        tag: "TECHNOLOGY & BUSINESS",
        accent: techGreen,
        headline: "NVIDIA REINSTATES\nJENSEN HUANG AS CEO",
        subtitle: "Founder Restored Unanimously Following Security Clearance",
        points: [
            "NVIDIA Board votes unanimously to return Huang to helm tech giant",
            "Federal discussions confirm no national security risks or violations",
            "Tech equities trigger broad global rally; Nasdaq surges over 2.1%",
            "Interim leader Colette Kress resumes full-time Chief Financial Officer role"
        ],
        statNum: "+2.1%",
        statTxt: "NASDAQ TECH SURGE",
        graphicId: 2
    ),
    NewsPanel(
        col: 0, row: 1,
        tag: "DEFENSE & WARFARE",
        accent: defenseOrange,
        headline: "UKRAINIAN SEA DRONES\nSINK RUSSIAN CORVETTE",
        subtitle: "Warship Merkury Destroyed in Mediterranean Docking",
        points: [
            "Seven Magura V5 naval drones sink Russian corvette in Libyan port",
            "Deepest long-range Ukrainian naval strike outside Black Sea waters",
            "European Commission formally proposes 19th Russia sanctions package",
            "Western intelligence warns of Russian satellite space-weapon tests"
        ],
        statNum: "7 DRONES",
        statTxt: "PORT BENGHAZI STRIKE",
        graphicId: 3
    ),
    NewsPanel(
        col: 1, row: 1,
        tag: "GLOBAL COMMERCE",
        accent: tradeBlue,
        headline: "EU & INDONESIA SIGN\nHISTORIC TRADE PACT",
        subtitle: "Decade of Free-Trade Negotiations Reaches Final Signing",
        points: [
            "Comprehensive Economic Partnership Agreement (CEPA) signed",
            "Eliminates 95%+ of mutual tariffs and secures critical mineral supply",
            "Direct European battery supply chains linked to Indonesian nickel",
            "Bilateral commerce projected to surpass €30B annually by 2030"
        ],
        statNum: "€32B+",
        statTxt: "ANNUAL BILATERAL TRADE",
        graphicId: 4
    ),
    NewsPanel(
        col: 2, row: 1,
        tag: "CULTURE & SOCIETY",
        accent: culturePurple,
        headline: "FIFA CONFIRMS USA BID\nFOR 2031 WOMEN'S CUP",
        subtitle: "United States Awarded 2031; UK to Host 2035 Tournament",
        points: [
            "FIFA Council officially designates U.S. as host for 2031 Women's World Cup",
            "England and UK home nations confirmed to host 2035 tournament edition",
            "Late Pope Francis's private spiritual diaries published worldwide",
            "Texts reveal deeply candid reflections overcoming severe spiritual crisis"
        ],
        statNum: "2031 / 35",
        statTxt: "WORLD CUP HOSTS LOCKED",
        graphicId: 5
    )
]

for p in panels {
    let x = colXs[p.col]
    let y = rowYs[p.row]
    
    // Panel Container
    drawRoundRect(x, y, cardW, cardH, 20, cardFill, cardStroke, 2)
    
    // Color Marker & Tag
    drawRect(x + 24, y + 24, 70, 7, p.accent)
    renderText(p.tag, x + 106, y + 16, cardW - 130, 28, 20, .heavy, p.accent)
    
    // Vector Illustration Box
    let ivX = x + cardW / 2
    let ivY = y + 130
    drawRoundRect(x + 24, y + 54, cardW - 48, 140, 14, NSColor(white: 0.04, alpha: 0.5), NSColor(white: 1, alpha: 0.08), 1)
    
    switch p.graphicId {
    case 0: // Climate globe
        drawCircle(ivX, ivY, 52, NSColor(calibratedRed: 0.10, green: 0.32, blue: 0.42, alpha: 1), mintTeal, 3)
        drawCircle(ivX - 16, ivY - 14, 18, NSColor(calibratedRed: 0.18, green: 0.54, blue: 0.45, alpha: 1))
        drawCircle(ivX + 20, ivY + 16, 22, NSColor(calibratedRed: 0.18, green: 0.54, blue: 0.45, alpha: 1))
        drawLine(ivX - 44, ivY - 50, ivX - 8, ivY, alertRed, 5)
        drawLine(ivX - 8, ivY, ivX + 16, ivY - 12, alertRed, 5)
        drawLine(ivX + 16, ivY - 12, ivX + 44, ivY + 48, alertRed, 5)
        drawLine(ivX - 90, ivY - 30, ivX - 90, ivY + 30, defenseOrange, 4)
        drawCircle(ivX - 90, ivY + 32, 10, defenseOrange)
        drawLine(ivX + 90, ivY - 30, ivX + 90, ivY + 30, mintTeal, 4)
        drawCircle(ivX + 90, ivY + 32, 10, mintTeal)
        
    case 1: // Defense Radar
        drawCircle(ivX, ivY, 54, NSColor(calibratedRed: 0.22, green: 0.08, blue: 0.10, alpha: 1), alertRed, 3)
        drawCircle(ivX, ivY, 36, .clear, NSColor(calibratedRed: 0.97, green: 0.42, blue: 0.42, alpha: 0.4), 1.5)
        drawCircle(ivX, ivY, 18, .clear, NSColor(calibratedRed: 0.97, green: 0.42, blue: 0.42, alpha: 0.4), 1.5)
        drawLine(ivX - 54, ivY, ivX + 54, ivY, NSColor(calibratedRed: 0.97, green: 0.42, blue: 0.42, alpha: 0.4), 1.5)
        drawLine(ivX, ivY - 54, ivX, ivY + 54, NSColor(calibratedRed: 0.97, green: 0.42, blue: 0.42, alpha: 0.4), 1.5)
        drawPoly([(ivX + 40, ivY - 40), (ivX + 10, ivY - 20), (ivX + 24, ivY - 6)], primaryText)
        drawLine(ivX + 40, ivY - 40, ivX - 25, ivY + 25, goldAccent, 3)
        
    case 2: // NVIDIA processor + Financial Chart
        drawRoundRect(ivX - 48, ivY - 42, 96, 84, 10, NSColor(calibratedRed: 0.08, green: 0.28, blue: 0.18, alpha: 1), techGreen, 3)
        for i in 0..<5 {
            let offset = CGFloat(i) * 16 - 32
            drawLine(ivX + offset, ivY - 52, ivX + offset, ivY - 42, goldAccent, 3)
            drawLine(ivX + offset, ivY + 42, ivX + offset, ivY + 52, goldAccent, 3)
        }
        renderText("AI", ivX - 24, ivY - 22, 48, 44, 32, .black, primaryText, .center, 0)
        drawLine(ivX + 90, ivY + 20, ivX + 90, ivY - 30, techGreen, 4)
        drawRect(ivX + 84, ivY + 6, 12, 24, techGreen)
        drawLine(ivX + 115, ivY + 36, ivX + 115, ivY - 44, techGreen, 4)
        drawRect(ivX + 109, ivY - 24, 12, 34, techGreen)
        
    case 3: // Maritime Drone Strike
        drawPoly([(ivX - 90, ivY + 12), (ivX + 60, ivY + 12), (ivX + 40, ivY + 36), (ivX - 70, ivY + 36)], NSColor(white: 0.55, alpha: 1))
        drawRect(ivX - 45, ivY - 14, 50, 26, NSColor(white: 0.70, alpha: 1))
        drawLine(ivX - 20, ivY - 36, ivX - 20, ivY - 14, primaryText, 3)
        drawPoly([(ivX + 105, ivY + 24), (ivX + 70, ivY + 18), (ivX + 75, ivY + 30)], defenseOrange)
        drawLine(ivX + 110, ivY + 24, ivX + 130, ivY + 24, mintTeal, 3)
        drawPoly([(ivX + 15, ivY + 8), (ivX + 35, ivY - 20), (ivX + 45, ivY + 4), (ivX + 65, ivY - 10), (ivX + 50, ivY + 22)], alertRed)
        drawCircle(ivX + 40, ivY + 4, 14, goldAccent)
        
    case 4: // Trade & Logistics
        drawPoly([(ivX - 85, ivY + 14), (ivX + 75, ivY + 14), (ivX + 55, ivY + 38), (ivX - 65, ivY + 38)], tradeBlue)
        drawRect(ivX - 50, ivY - 14, 32, 26, goldAccent)
        drawRect(ivX - 14, ivY - 14, 32, 26, mintTeal)
        drawRect(ivX + 22, ivY - 14, 32, 26, defenseOrange)
        drawRect(ivX - 32, ivY - 38, 32, 24, techGreen)
        drawRect(ivX + 4, ivY - 38, 32, 24, culturePurple)
        drawLine(ivX - 90, ivY - 36, ivX - 70, ivY - 36, primaryText, 3)
        drawLine(ivX + 70, ivY - 36, ivX + 90, ivY - 36, primaryText, 3)
        
    default: // FIFA World Cup Trophy
        drawPoly([(ivX - 32, ivY - 38), (ivX + 32, ivY - 38), (ivX + 22, ivY + 10), (ivX - 22, ivY + 10)], goldAccent)
        drawRect(ivX - 10, ivY + 10, 20, 20, goldAccent)
        drawRect(ivX - 26, ivY + 30, 52, 10, goldAccent)
        drawCircle(ivX, ivY - 38, 22, primaryText, goldAccent, 3)
        drawCircle(ivX, ivY - 38, 8, NSColor(calibratedRed: 0.1, green: 0.1, blue: 0.18, alpha: 1))
        drawCircle(ivX - 80, ivY - 10, 6, goldAccent)
        drawCircle(ivX + 80, ivY - 10, 6, goldAccent)
    }
    
    // Headline
    renderText(p.headline, x + 24, y + 212, cardW - 48, 88, 33, .heavy, primaryText, .left, 4)
    
    // Subtitle
    renderText(p.subtitle, x + 24, y + 308, cardW - 48, 54, 21, .bold, p.accent, .left, 3)
    
    // Points
    var py = y + 372
    for pt in p.points {
        drawCircle(x + 32, py + 12, 5, p.accent)
        renderText(pt, x + 48, py, cardW - 74, 54, 19, .medium, secondaryText, .left, 2)
        py += 64
    }
    
    // Bottom Stat Box inside Card
    drawRoundRect(x + 24, y + cardH - 104, cardW - 48, 80, 12, NSColor(white: 0.04, alpha: 0.65), NSColor(white: 1, alpha: 0.08), 1)
    renderText(p.statNum, x + 44, y + cardH - 96, 260, 42, 34, .black, goldAccent)
    renderText(p.statTxt, x + 44, y + cardH - 52, cardW - 90, 26, 17, .heavy, tertiaryText)
}

// Global Financial Ticker
drawRoundRect(80, 1948, 1888, 76, 14, NSColor(calibratedRed: 0.05, green: 0.08, blue: 0.14, alpha: 0.95), cardStroke, 1.5)
let ticker = "GLOBAL DATA: S&P 500 ▲ 1.4%  •  NASDAQ ▲ 2.1% (TECH RALLY)  •  BRENT CRUDE $74.20 ▼ 0.8%  •  GOLD $2,714/OZ ▲ 0.3%  •  EU-INDONESIA CEPA €32B/YR  •  COP31 190+ DEADLOCK"
renderText(ticker, 100, 1970, 1848, 32, 22, .bold, goldAccent, .center)

canvas.unlockFocus()

// High-resolution antialiased 1024x1024 PNG export
guard let cg = canvas.cgImage(forProposedRect: nil, context: nil, hints: nil),
      let bitmap = CGContext(data: nil, width: 1024, height: 1024, bitsPerComponent: 8, bytesPerRow: 0,
                             space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { fatalError("Bitmap context failed") }

bitmap.interpolationQuality = .high
bitmap.draw(cg, in: CGRect(x: 0, y: 0, width: 1024, height: 1024))

guard let finalImage = bitmap.makeImage(),
      let pngData = NSBitmapImageRep(cgImage: finalImage).representation(using: .png, properties: [:]) else { fatalError("PNG encoding failed") }

let outputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "entry.png"
try pngData.write(to: URL(fileURLWithPath: outputPath))
print("Generated \(outputPath) (\(pngData.count) bytes)")
