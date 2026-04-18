import Foundation

func abbreviate ( _ number: Double, _ symbol: String ) -> String {
    if number >= 1_000_000_000_000 {
        let shortened = number/1_000_000_000_000
        return symbol + String(format: "%.0f", shortened) + "T"
    }
    if number >= 1_000_000_000 {
        let shortened = number/1_000_000_000
        return symbol + String(format: "%.0f", shortened) + "B"
    }
    if number >= 1_000_000 {
        let shortened = number/1_000_000
        return symbol + String(format: "%.0f", shortened) + "M"
    }
    if number >= 1_000{
        let shortened = number/1_000
        return symbol + String(format: "%.0f", shortened) + "K"
    }
    
    return symbol + String (format: "%.2f", number)
}
