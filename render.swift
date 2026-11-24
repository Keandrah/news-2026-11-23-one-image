import AppKit

let W: CGFloat = 2048
let H: CGFloat = 2048
let image = NSImage(size: NSSize(width: W, height: H))
image.lockFocus()
guard let ctx = NSGraphicsContext.current?.cgContext else { fatalError("no context") }

// Color Palette
let bgDark = NSColor(calibratedRed: 0.040, green: 0.065, blue: 0.120, alpha: 1.0)
let bgDark2 = NSColor(calibratedRed: 0.065, green: 0.100, blue: 0.180, alpha: 1.0)
let cardBg = NSColor(calibratedRed: 0.085, green: 0.130, blue: 0.225, alpha: 0.95)
let cardBorder = NSColor(calibratedRed: 0.180, green: 0.250, blue: 0.380, alpha: 0.6)

let white = NSColor(calibratedRed: 0.98, green: 0.98, blue: 1.0, alpha: 1.0)
let muted = NSColor(calibratedRed: 0.65, green: 0.73, blue: 0.83, alpha: 1.0)
let submuted = NSColor(calibratedRed: 0.48, green: 0.56, blue: 0.68, alpha: 1.0)
let gold = NSColor(calibratedRed: 0.98, green: 0.72, blue: 0.20, alpha: 1.0)
let teal = NSColor(calibratedRed: 0.18, green: 0.83, blue: 0.75, alpha: 1.0)
let red = NSColor(calibratedRed: 0.97, green: 0.42, blue: 0.42, alpha: 1.0)
let green = NSColor(calibratedRed: 0.20, green: 0.83, blue: 0.60, alpha: 1.0)
let orange = NSColor(calibratedRed: 0.98, green: 0.58, blue: 0.24, alpha: 1.0)
let blue = NSColor(calibratedRed: 0.25, green: 0.68, blue: 0.98, alpha: 1.0)
let purple = NSColor(calibratedRed: 0.75, green: 0.52, blue: 0.98, alpha: 1.0)

func rect(_ x: CGFloat, _ yTop: CGFloat, _ w: CGFloat, _ h: CGFloat, _ c: NSColor) {
    c.setFill()
    NSRect(x: x, y: H - yTop - h, width: w, height: h).fill()
}

func roundRect(_ x: CGFloat, _ yTop: CGFloat, _ w: CGFloat, _ h: CGFloat, _ r: CGFloat, _ fill: NSColor, _ stroke: NSColor? = nil, _ strokeW: CGFloat = 1) {
    let p = NSBezierPath(roundedRect: NSRect(x: x, y: H - yTop - h, width: w, height: h), xRadius: r, yRadius: r)
    fill.setFill()
    p.fill()
    if let stroke = stroke {
        stroke.setStroke()
        p.lineWidth = strokeW
        p.stroke()
    }
}

func line(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ c: NSColor, _ w: CGFloat = 2) {
    c.setStroke()
    let p = NSBezierPath()
    p.move(to: NSPoint(x: x1, y: H - y1))
    p.line(to: NSPoint(x: x2, y: H - y2))
    p.lineWidth = w
    p.stroke()
}

func circle(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ fill: NSColor, _ stroke: NSColor? = nil, _ strokeW: CGFloat = 2) {
    let p = NSBezierPath(ovalIn: NSRect(x: cx - r, y: H - cy - r, width: 2 * r, height: 2 * r))
    fill.setFill()
    p.fill()
    if let stroke = stroke {
        stroke.setStroke()
        p.lineWidth = strokeW
        p.stroke()
    }
}

func poly(_ pts: [(CGFloat, CGFloat)], _ fill: NSColor, _ stroke: NSColor? = nil, _ strokeW: CGFloat = 1) {
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

func label(_ s: String, _ x: CGFloat, _ yTop: CGFloat, _ w: CGFloat, _ h: CGFloat,
           _ size: CGFloat, _ weight: NSFont.Weight, _ c: NSColor, _ align: NSTextAlignment = .left, _ spacing: CGFloat = 3) {
    let font = NSFont.systemFont(ofSize: size, weight: weight)
    let para = NSMutableParagraphStyle()
    para.alignment = align
    para.lineBreakMode = .byWordWrapping
    para.lineSpacing = spacing
    let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: c, .paragraphStyle: para]
    NSString(string: s).draw(in: NSRect(x: x, y: H - yTop - h, width: w, height: h), withAttributes: attrs)
}

// Background gradient
NSGradient(starting: bgDark, ending: bgDark2)?.draw(in: NSRect(x: 0, y: 0, width: W, height: H), angle: -45)

// Subtle background grid
for x in stride(from: CGFloat(0), through: W, by: 64) { line(x, 0, x, H, NSColor(white: 1, alpha: 0.015), 1) }
for y in stride(from: CGFloat(0), through: H, by: 64) { line(0, y, W, y, NSColor(white: 1, alpha: 0.015), 1) }

// Top Gold Bar
rect(0, 0, W, 18, gold)

// Masthead Header
label("THE GLOBAL DISPATCH  •  WORLD NEWS INTELLIGENCE", 80, 48, 1200, 36, 26, .bold, gold)
label("DAILY EDITION #428", W - 480, 48, 400, 36, 24, .medium, submuted, .right)

label("MONDAY, 23 NOVEMBER 2026", 76, 88, 1888, 100, 84, .black, white)
label("A COMPREHENSIVE VISUAL SUMMARY OF TODAY'S TOP GLOBAL EVENTS IN ONE IMAGE", 80, 194, 1888, 36, 26, .medium, muted)

// Datelines Bar
roundRect(80, 242, 1888, 52, 10, NSColor(calibratedRed: 0.06, green: 0.09, blue: 0.16, alpha: 0.9), cardBorder, 1.5)
let datelines = "ANTALYA (COP31)  •  WASHINGTON (WHITE HOUSE)  •  SANTA CLARA (NVIDIA)  •  BENGHAZI (NAVAL STRIKE)  •  BRUSSELS (EU PACT)  •  JAKARTA"
label(datelines, 100, 256, 1848, 28, 21, .bold, submuted, .center)

// Divider
line(80, 314, W - 80, 314, NSColor(white: 1, alpha: 0.12), 2)

// Card Grid Parameters
// 3 Columns x 2 Rows
let cardW: CGFloat = 598
let cardH: CGFloat = 780
let colXs: [CGFloat] = [80, 725, 1370]
let rowYs: [CGFloat] = [336, 1144]

struct Story {
    let col: Int
    let row: Int
    let tag: String
    let accent: NSColor
    let headline: String
    let subtitle: String
    let points: [String]
    let statNumber: String
    let statLabel: String
    let iconKind: Int
}

let stories: [Story] = [
    Story(
        col: 0, row: 0,
        tag: "CLIMATE & ENVIRONMENT",
        accent: teal,
        headline: "COP31 CLIMATE SUMMIT\nCOLLAPSES IN ANTALYA",
        subtitle: "190+ Nations Fail to Reach Cover Pact as Fossil Deadlock Persists",
        points: [
            "Antalya conference ends in bitter deadlock after 48h of overtime",
            "Divisions over binding fossil-fuel phase-out language sink agreement",
            "UN Secretary-General António Guterres calls outcome 'deeply disappointing'",
            "Voluntary 150-nation '35x35' clean power delivery framework salvaged"
        ],
        statNumber: "190+",
        statLabel: "NATIONS DEADLOCKED",
        iconKind: 0
    ),
    Story(
        col: 1, row: 0,
        tag: "GEOPOLITICS & SECURITY",
        accent: red,
        headline: "TRUMP WARNS OF NEW YEAR\nSTRIKES AGAINST IRAN",
        subtitle: "Military Strikes Signaled if Diplomatic Negotiations Fail",
        points: [
            "U.S. President warns of potential military action after New Year",
            "Ongoing naval blockade heavily chokes Iranian crude exports & revenue",
            "Widespread domestic truck driver fuel strikes spread across provinces",
            "West Bank settler violence sparks sharp global security condemnation"
        ],
        statNumber: "JAN 2027",
        statLabel: "STRIKE DEADLINE SIGNALED",
        iconKind: 1
    ),
    Story(
        col: 2, row: 0,
        tag: "TECHNOLOGY & BUSINESS",
        accent: green,
        headline: "NVIDIA REINSTATES\nJENSEN HUANG AS CEO",
        subtitle: "Founder Restored Unanimously Following Security Clearance",
        points: [
            "NVIDIA Board votes unanimously to return Huang to helm tech giant",
            "Federal discussions confirm no national security risks or violations",
            "Tech equities trigger broad global rally; Nasdaq surges over 2.1%",
            "Interim leader Colette Kress resumes full-time Chief Financial Officer role"
        ],
        statNumber: "+2.1%",
        statLabel: "NASDAQ TECH SURGE",
        iconKind: 2
    ),
    Story(
        col: 0, row: 1,
        tag: "DEFENSE & WARFARE",
        accent: orange,
        headline: "UKRAINIAN SEA DRONES\nSINK RUSSIAN CORVETTE",
        subtitle: "Warship Merkury Destroyed in Mediterranean Docking",
        points: [
            "Seven Magura V5 naval drones sink Russian corvette in Libyan port",
            "Deepest long-range Ukrainian naval strike outside Black Sea waters",
            "European Commission formally proposes 19th Russia sanctions package",
            "Western intelligence warns of Russian satellite space-weapon tests"
        ],
        statNumber: "7 DRONES",
        statLabel: "PORT BENGHAZI STRIKE",
        iconKind: 3
    ),
    Story(
        col: 1, row: 1,
        tag: "GLOBAL COMMERCE",
        accent: blue,
        headline: "EU & INDONESIA SIGN\nHISTORIC TRADE PACT",
        subtitle: "Decade of Free-Trade Negotiations Reaches Final Signing",
        points: [
            "Comprehensive Economic Partnership Agreement (CEPA) signed",
            "Eliminates 95%+ of mutual tariffs and secures critical mineral supply",
            "Direct European battery supply chains linked to Indonesian nickel",
            "Bilateral commerce projected to surpass €30B annually by 2030"
        ],
        statNumber: "€32B+",
        statLabel: "ANNUAL BILATERAL TRADE",
        iconKind: 4
    ),
    Story(
        col: 2, row: 1,
        tag: "CULTURE & SOCIETY",
        accent: purple,
        headline: "FIFA CONFIRMS USA BID\nFOR 2031 WOMEN'S CUP",
        subtitle: "United States Awarded 2031; UK to Host 2035 Tournament",
        points: [
            "FIFA Council officially designates U.S. as host for 2031 Women's World Cup",
            "England and UK home nations confirmed to host 2035 tournament edition",
            "Late Pope Francis's private spiritual diaries published worldwide",
            "Texts reveal deeply candid reflections overcoming severe spiritual crisis"
        ],
        statNumber: "2031 / 35",
        statLabel: "WORLD CUP HOSTS LOCKED",
        iconKind: 5
    )
]

for s in stories {
    let x = colXs[s.col]
    let y = rowYs[s.row]
    
    // Card Container
    roundRect(x, y, cardW, cardH, 20, cardBg, cardBorder, 2)
    
    // Card Header Bar
    rect(x + 24, y + 24, 70, 7, s.accent)
    label(s.tag, x + 106, y + 16, cardW - 130, 28, 20, .heavy, s.accent)
    
    // Vector Illustration Box
    let ivX = x + cardW / 2
    let ivY = y + 130
    roundRect(x + 24, y + 54, cardW - 48, 140, 14, NSColor(white: 0.04, alpha: 0.5), NSColor(white: 1, alpha: 0.08), 1)
    
    switch s.iconKind {
    case 0: // Climate: Globe with divide and sun/ice
        circle(ivX, ivY, 52, NSColor(calibratedRed: 0.10, green: 0.32, blue: 0.42, alpha: 1), teal, 3)
        // Globe continents outline
        circle(ivX - 16, ivY - 14, 18, NSColor(calibratedRed: 0.18, green: 0.54, blue: 0.45, alpha: 1))
        circle(ivX + 20, ivY + 16, 22, NSColor(calibratedRed: 0.18, green: 0.54, blue: 0.45, alpha: 1))
        // Jagged crack line
        line(ivX - 44, ivY - 50, ivX - 8, ivY, red, 5)
        line(ivX - 8, ivY, ivX + 16, ivY - 12, red, 5)
        line(ivX + 16, ivY - 12, ivX + 44, ivY + 48, red, 5)
        // Small thermometers
        line(ivX - 90, ivY - 30, ivX - 90, ivY + 30, orange, 4)
        circle(ivX - 90, ivY + 32, 10, orange)
        line(ivX + 90, ivY - 30, ivX + 90, ivY + 30, teal, 4)
        circle(ivX + 90, ivY + 32, 10, teal)
        
    case 1: // Iran strike warning: Radar / Missile / Silhouette
        circle(ivX, ivY, 54, NSColor(calibratedRed: 0.22, green: 0.08, blue: 0.10, alpha: 1), red, 3)
        // Radar rings
        circle(ivX, ivY, 36, .clear, NSColor(calibratedRed: 0.97, green: 0.42, blue: 0.42, alpha: 0.4), 1.5)
        circle(ivX, ivY, 18, .clear, NSColor(calibratedRed: 0.97, green: 0.42, blue: 0.42, alpha: 0.4), 1.5)
        line(ivX - 54, ivY, ivX + 54, ivY, NSColor(calibratedRed: 0.97, green: 0.42, blue: 0.42, alpha: 0.4), 1.5)
        line(ivX, ivY - 54, ivX, ivY + 54, NSColor(calibratedRed: 0.97, green: 0.42, blue: 0.42, alpha: 0.4), 1.5)
        // Jet / Missile triangle
        poly([(ivX + 40, ivY - 40), (ivX + 10, ivY - 20), (ivX + 24, ivY - 6)], white)
        line(ivX + 40, ivY - 40, ivX - 25, ivY + 25, gold, 3)
        
    case 2: // NVIDIA Jensen Huang: Silicon chip + Candlestick chart
        roundRect(ivX - 48, ivY - 42, 96, 84, 10, NSColor(calibratedRed: 0.08, green: 0.28, blue: 0.18, alpha: 1), green, 3)
        // Silicon pins
        for i in 0..<5 {
            let offset = CGFloat(i) * 16 - 32
            line(ivX + offset, ivY - 52, ivX + offset, ivY - 42, gold, 3)
            line(ivX + offset, ivY + 42, ivX + offset, ivY + 52, gold, 3)
        }
        // Core icon
        label("AI", ivX - 24, ivY - 22, 48, 44, 32, .black, white, .center, 0)
        // Ascending Candlesticks
        line(ivX + 90, ivY + 20, ivX + 90, ivY - 30, green, 4)
        rect(ivX + 84, ivY + 6, 12, 24, green)
        line(ivX + 115, ivY + 36, ivX + 115, ivY - 44, green, 4)
        rect(ivX + 109, ivY - 24, 12, 34, green)
        
    case 3: // Ukraine Sea Drone vs Warship
        // Warship hull
        poly([(ivX - 90, ivY + 12), (ivX + 60, ivY + 12), (ivX + 40, ivY + 36), (ivX - 70, ivY + 36)], NSColor(white: 0.55, alpha: 1))
        rect(ivX - 45, ivY - 14, 50, 26, NSColor(white: 0.70, alpha: 1))
        line(ivX - 20, ivY - 36, ivX - 20, ivY - 14, white, 3)
        // Drone incoming
        poly([(ivX + 105, ivY + 24), (ivX + 70, ivY + 18), (ivX + 75, ivY + 30)], orange)
        line(ivX + 110, ivY + 24, ivX + 130, ivY + 24, teal, 3)
        // Explosion burst
        poly([(ivX + 15, ivY + 8), (ivX + 35, ivY - 20), (ivX + 45, ivY + 4), (ivX + 65, ivY - 10), (ivX + 50, ivY + 22)], red)
        circle(ivX + 40, ivY + 4, 14, gold)
        
    case 4: // EU - Indonesia Trade Pact
        // Cargo ship + Container stack
        poly([(ivX - 85, ivY + 14), (ivX + 75, ivY + 14), (ivX + 55, ivY + 38), (ivX - 65, ivY + 38)], blue)
        rect(ivX - 50, ivY - 14, 32, 26, gold)
        rect(ivX - 14, ivY - 14, 32, 26, teal)
        rect(ivX + 22, ivY - 14, 32, 26, orange)
        rect(ivX - 32, ivY - 38, 32, 24, green)
        rect(ivX + 4, ivY - 38, 32, 24, purple)
        // Connecting handshake / arc
        line(ivX - 90, ivY - 36, ivX - 70, ivY - 36, white, 3)
        line(ivX + 70, ivY - 36, ivX + 90, ivY - 36, white, 3)
        
    default: // FIFA World Cup & Culture
        // Trophy cup
        poly([(ivX - 32, ivY - 38), (ivX + 32, ivY - 38), (ivX + 22, ivY + 10), (ivX - 22, ivY + 10)], gold)
        rect(ivX - 10, ivY + 10, 20, 20, gold)
        rect(ivX - 26, ivY + 30, 52, 10, gold)
        circle(ivX, ivY - 38, 22, white, gold, 3)
        // Soccer ball pattern
        circle(ivX, ivY - 38, 8, NSColor(calibratedRed: 0.1, green: 0.1, blue: 0.18, alpha: 1))
        // Star accents
        circle(ivX - 80, ivY - 10, 6, gold)
        circle(ivX + 80, ivY - 10, 6, gold)
    }
    
    // Headline
    label(s.headline, x + 24, y + 212, cardW - 48, 88, 33, .heavy, white, .left, 4)
    
    // Subtitle
    label(s.subtitle, x + 24, y + 308, cardW - 48, 54, 21, .bold, s.accent, .left, 3)
    
    // Bullet Points
    var py = y + 372
    for p in s.points {
        // Bullet circle
        circle(x + 32, py + 12, 5, s.accent)
        label(p, x + 48, py, cardW - 74, 54, 19, .medium, muted, .left, 2)
        py += 64
    }
    
    // Bottom Stat Box inside Card
    roundRect(x + 24, y + cardH - 104, cardW - 48, 80, 12, NSColor(white: 0.04, alpha: 0.65), NSColor(white: 1, alpha: 0.08), 1)
    label(s.statNumber, x + 44, y + cardH - 96, 260, 42, 34, .black, gold)
    label(s.statLabel, x + 44, y + cardH - 52, cardW - 90, 26, 17, .heavy, submuted)
}

// Bottom Ticker / Market Bar
roundRect(80, 1948, 1888, 76, 14, NSColor(calibratedRed: 0.05, green: 0.08, blue: 0.14, alpha: 0.95), cardBorder, 1.5)
let ticker = "GLOBAL DATA: S&P 500 ▲ 1.4%  •  NASDAQ ▲ 2.1% (TECH RALLY)  •  BRENT CRUDE $74.20 ▼ 0.8%  •  GOLD $2,714/OZ ▲ 0.3%  •  EU-INDONESIA CEPA €32B/YR  •  COP31 190+ DEADLOCK"
label(ticker, 100, 1970, 1848, 32, 22, .bold, gold, .center)

image.unlockFocus()

// Downscale to 1024x1024 for pristine antialiased crisp rendering
guard let cg = image.cgImage(forProposedRect: nil, context: nil, hints: nil),
      let bitmap = CGContext(data: nil, width: 1024, height: 1024, bitsPerComponent: 8, bytesPerRow: 0,
                             space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { fatalError("no bitmap context") }

bitmap.interpolationQuality = .high
bitmap.draw(cg, in: CGRect(x: 0, y: 0, width: 1024, height: 1024))

guard let finalImage = bitmap.makeImage(),
      let png = NSBitmapImageRep(cgImage: finalImage).representation(using: .png, properties: [:]) else { fatalError("png failed") }

let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "entry.png"
try png.write(to: URL(fileURLWithPath: out))
print("Wrote \(out) (\(png.count) bytes)")
