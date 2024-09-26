import Foundation

func main() {
    printBanner()
    let semaphore = DispatchSemaphore(value: 0)

    DispatchQueue.global().async {
        do {
            try startDownload()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        semaphore.signal()
    }

    _ = semaphore.wait(timeout: .distantFuture)
}

func printBanner() {
    print("""
    MM    MM                               KK  KK BBBBB   HH   HH DDDDD  
    MMM  MMM  oooo  nn nnn    eee  yy   yy KK KK  BB   B  HH   HH DD  DD 
    MM MM MM oo  oo nnn  nn ee   e yy   yy KKKK   BBBBBB  HHHHHHH DD   DD
    MM    MM oo  oo nn   nn eeeee   yyyyyy KK KK  BB   BB HH   HH DD   DD
    MM    MM  oooo  nn   nn  eeeee      yy KK  KK BBBBBB  HH   HH DDDDDD 
                                    yyyyy                                                                         
    """)
    print("")
    print("$ Starting exploiting from our favorite money grubber grifter's wallpaper 'app'...")
}

func startDownload() throws {
    let url = URL(string: "https://storage.googleapis.com/panels-api/data/20240916/media-1a-i-p~s")!
    let data = try Data(contentsOf: url)
    let root = try JSONDecoder().decode(Root.self, from: data)
    guard let jsonData = root.data else {
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "⛔ JSON does not have a \"data\" property at its root."])
    }
    let saveDirectory = FileManager.default.currentDirectoryPath + "/MoneyKBHD_"
    if !FileManager.default.fileExists(atPath: saveDirectory) {
        try FileManager.default.createDirectory(atPath: saveDirectory, withIntermediateDirectories: true)
        print("💸 Created directory: \(saveDirectory)")
    }
    var imageIndex = 1
    for (_, item) in jsonData {
        if let imageUrl = item.dhd.flatMap(URL.init) {
            print("👀 Found image URL!")
            Thread.sleep(forTimeInterval: 0.1)
            let ext = imageUrl.pathExtension.isEmpty ? "jpg" : imageUrl.pathExtension
            let filePath = saveDirectory + "/\(imageIndex).\(ext)"
            try saveImage(from: imageUrl, to: filePath)
            print("🗃️ Saved wallpaper to \(filePath)")
            imageIndex += 1
            Thread.sleep(forTimeInterval: 0.25)
        }
    }
}

func saveImage(from url: URL, to filePath: String) throws {
    let data = try Data(contentsOf: url)
    try data.write(to: URL(fileURLWithPath: filePath))
}

struct Root: Codable {
    let data: [String: Item]?
}

struct Item: Codable {
    let dhd: String?
}

main()
