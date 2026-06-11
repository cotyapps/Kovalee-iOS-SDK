#if os(iOS)
import Foundation

// Country data structure
@available(iOS 17, *)
struct Country {
    let name: String
    let code: String
    let flag: String
    let phoneCode: String

    static func country(using identifier: String) -> Country? {
       return supportedCountries.first {
            $0.code == identifier
        }
    }

    static func local() -> Country? {
        let locale = Locale.current
        guard
            let countryCode = locale.language.region?.identifier,
            let country = Country.country(using: countryCode) else {
            return nil
        }
        return country
    }

    static let placeholder: Country = Country(name: "United States", code: "US", flag: "🇺🇸", phoneCode: "+1")

    static let supportedCountries: [Country] = [
        Country(name: "Afghanistan", code: "AF", flag: "🇦🇫", phoneCode: "+93"),
        Country(name: "Albania", code: "AL", flag: "🇦🇱", phoneCode: "+355"),
        Country(name: "Algeria", code: "DZ", flag: "🇩🇿", phoneCode: "+213"),
        Country(name: "Andorra", code: "AD", flag: "🇦🇩", phoneCode: "+376"),
        Country(name: "Angola", code: "AO", flag: "🇦🇴", phoneCode: "+244"),
        Country(name: "Argentina", code: "AR", flag: "🇦🇷", phoneCode: "+54"),
        Country(name: "Armenia", code: "AM", flag: "🇦🇲", phoneCode: "+374"),
        Country(name: "Australia", code: "AU", flag: "🇦🇺", phoneCode: "+61"),
        Country(name: "Austria", code: "AT", flag: "🇦🇹", phoneCode: "+43"),
        Country(name: "Azerbaijan", code: "AZ", flag: "🇦🇿", phoneCode: "+994"),
        Country(name: "Bahrain", code: "BH", flag: "🇧🇭", phoneCode: "+973"),
        Country(name: "Bangladesh", code: "BD", flag: "🇧🇩", phoneCode: "+880"),
        Country(name: "Belarus", code: "BY", flag: "🇧🇾", phoneCode: "+375"),
        Country(name: "Belgium", code: "BE", flag: "🇧🇪", phoneCode: "+32"),
        Country(name: "Bolivia", code: "BO", flag: "🇧🇴", phoneCode: "+591"),
        Country(name: "Brazil", code: "BR", flag: "🇧🇷", phoneCode: "+55"),
        Country(name: "Bulgaria", code: "BG", flag: "🇧🇬", phoneCode: "+359"),
        Country(name: "Cambodia", code: "KH", flag: "🇰🇭", phoneCode: "+855"),
        Country(name: "Canada", code: "CA", flag: "🇨🇦", phoneCode: "+1"),
        Country(name: "Chile", code: "CL", flag: "🇨🇱", phoneCode: "+56"),
        Country(name: "China", code: "CN", flag: "🇨🇳", phoneCode: "+86"),
        Country(name: "Colombia", code: "CO", flag: "🇨🇴", phoneCode: "+57"),
        Country(name: "Croatia", code: "HR", flag: "🇭🇷", phoneCode: "+385"),
        Country(name: "Cuba", code: "CU", flag: "🇨🇺", phoneCode: "+53"),
        Country(name: "Czech Republic", code: "CZ", flag: "🇨🇿", phoneCode: "+420"),
        Country(name: "Denmark", code: "DK", flag: "🇩🇰", phoneCode: "+45"),
        Country(name: "Ecuador", code: "EC", flag: "🇪🇨", phoneCode: "+593"),
        Country(name: "Egypt", code: "EG", flag: "🇪🇬", phoneCode: "+20"),
        Country(name: "Estonia", code: "EE", flag: "🇪🇪", phoneCode: "+372"),
        Country(name: "Finland", code: "FI", flag: "🇫🇮", phoneCode: "+358"),
        Country(name: "France", code: "FR", flag: "🇫🇷", phoneCode: "+33"),
        Country(name: "Germany", code: "DE", flag: "🇩🇪", phoneCode: "+49"),
        Country(name: "Ghana", code: "GH", flag: "🇬🇭", phoneCode: "+233"),
        Country(name: "Greece", code: "GR", flag: "🇬🇷", phoneCode: "+30"),
        Country(name: "Hungary", code: "HU", flag: "🇭🇺", phoneCode: "+36"),
        Country(name: "Iceland", code: "IS", flag: "🇮🇸", phoneCode: "+354"),
        Country(name: "India", code: "IN", flag: "🇮🇳", phoneCode: "+91"),
        Country(name: "Indonesia", code: "ID", flag: "🇮🇩", phoneCode: "+62"),
        Country(name: "Iran", code: "IR", flag: "🇮🇷", phoneCode: "+98"),
        Country(name: "Iraq", code: "IQ", flag: "🇮🇶", phoneCode: "+964"),
        Country(name: "Ireland", code: "IE", flag: "🇮🇪", phoneCode: "+353"),
        Country(name: "Israel", code: "IL", flag: "🇮🇱", phoneCode: "+972"),
        Country(name: "Italy", code: "IT", flag: "🇮🇹", phoneCode: "+39"),
        Country(name: "Japan", code: "JP", flag: "🇯🇵", phoneCode: "+81"),
        Country(name: "Jordan", code: "JO", flag: "🇯🇴", phoneCode: "+962"),
        Country(name: "Kazakhstan", code: "KZ", flag: "🇰🇿", phoneCode: "+7"),
        Country(name: "Kenya", code: "KE", flag: "🇰🇪", phoneCode: "+254"),
        Country(name: "Kuwait", code: "KW", flag: "🇰🇼", phoneCode: "+965"),
        Country(name: "Latvia", code: "LV", flag: "🇱🇻", phoneCode: "+371"),
        Country(name: "Lebanon", code: "LB", flag: "🇱🇧", phoneCode: "+961"),
        Country(name: "Lithuania", code: "LT", flag: "🇱🇹", phoneCode: "+370"),
        Country(name: "Luxembourg", code: "LU", flag: "🇱🇺", phoneCode: "+352"),
        Country(name: "Malaysia", code: "MY", flag: "🇲🇾", phoneCode: "+60"),
        Country(name: "Mexico", code: "MX", flag: "🇲🇽", phoneCode: "+52"),
        Country(name: "Morocco", code: "MA", flag: "🇲🇦", phoneCode: "+212"),
        Country(name: "Netherlands", code: "NL", flag: "🇳🇱", phoneCode: "+31"),
        Country(name: "New Zealand", code: "NZ", flag: "🇳🇿", phoneCode: "+64"),
        Country(name: "Nigeria", code: "NG", flag: "🇳🇬", phoneCode: "+234"),
        Country(name: "Norway", code: "NO", flag: "🇳🇴", phoneCode: "+47"),
        Country(name: "Pakistan", code: "PK", flag: "🇵🇰", phoneCode: "+92"),
        Country(name: "Peru", code: "PE", flag: "🇵🇪", phoneCode: "+51"),
        Country(name: "Philippines", code: "PH", flag: "🇵🇭", phoneCode: "+63"),
        Country(name: "Poland", code: "PL", flag: "🇵🇱", phoneCode: "+48"),
        Country(name: "Portugal", code: "PT", flag: "🇵🇹", phoneCode: "+351"),
        Country(name: "Qatar", code: "QA", flag: "🇶🇦", phoneCode: "+974"),
        Country(name: "Romania", code: "RO", flag: "🇷🇴", phoneCode: "+40"),
        Country(name: "Russia", code: "RU", flag: "🇷🇺", phoneCode: "+7"),
        Country(name: "Saudi Arabia", code: "SA", flag: "🇸🇦", phoneCode: "+966"),
        Country(name: "Singapore", code: "SG", flag: "🇸🇬", phoneCode: "+65"),
        Country(name: "Slovakia", code: "SK", flag: "🇸🇰", phoneCode: "+421"),
        Country(name: "Slovenia", code: "SI", flag: "🇸🇮", phoneCode: "+386"),
        Country(name: "South Africa", code: "ZA", flag: "🇿🇦", phoneCode: "+27"),
        Country(name: "South Korea", code: "KR", flag: "🇰🇷", phoneCode: "+82"),
        Country(name: "Spain", code: "ES", flag: "🇪🇸", phoneCode: "+34"),
        Country(name: "Sri Lanka", code: "LK", flag: "🇱🇰", phoneCode: "+94"),
        Country(name: "Sweden", code: "SE", flag: "🇸🇪", phoneCode: "+46"),
        Country(name: "Switzerland", code: "CH", flag: "🇨🇭", phoneCode: "+41"),
        Country(name: "Taiwan", code: "TW", flag: "🇹🇼", phoneCode: "+886"),
        Country(name: "Thailand", code: "TH", flag: "🇹🇭", phoneCode: "+66"),
        Country(name: "Turkey", code: "TR", flag: "🇹🇷", phoneCode: "+90"),
        Country(name: "Ukraine", code: "UA", flag: "🇺🇦", phoneCode: "+380"),
        Country(name: "United Arab Emirates", code: "AE", flag: "🇦🇪", phoneCode: "+971"),
        Country(name: "United Kingdom", code: "GB", flag: "🇬🇧", phoneCode: "+44"),
        Country(name: "United States", code: "US", flag: "🇺🇸", phoneCode: "+1"),
        Country(name: "Uruguay", code: "UY", flag: "🇺🇾", phoneCode: "+598"),
        Country(name: "Venezuela", code: "VE", flag: "🇻🇪", phoneCode: "+58"),
        Country(name: "Vietnam", code: "VN", flag: "🇻🇳", phoneCode: "+84")
    ]

}
#endif
