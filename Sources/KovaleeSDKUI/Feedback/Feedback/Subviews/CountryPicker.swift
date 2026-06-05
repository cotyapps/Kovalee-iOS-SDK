#if os(iOS)
import SwiftUI

@available(iOS 17, *)
struct CountryPicker: View {
	@Binding var selectedCountryCode: String
	let style: FeedbackStyle
    let countries: [Country] = Country.supportedCountries

	private var selectedCountry: Country? {
        countries.first { $0.code == selectedCountryCode }
	}

	var body: some View {
		Menu {
			ForEach(countries, id: \.code) { country in
				Button(action: {
					selectedCountryCode = country.code
				}) {
					Text(verbatim: "\(country.flag) \(country.phoneCode) \(country.name)")
						.foregroundStyle(.primary)
				}
			}
		} label: {
			HStack(spacing: 4) {
                Text(verbatim: selectedCountry?.flag ?? Country.placeholder.flag)
				Text(verbatim: selectedCountry?.phoneCode ?? Country.placeholder.phoneCode)
					.foregroundColor(style.textColor)
			}
			.font(.body)
			.padding(.horizontal, 12)
			.padding(.vertical, 12)
			.background(style.fieldBackgroundColor)
			.cornerRadius(8)
		}
	}
}
#endif
