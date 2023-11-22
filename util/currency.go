package util

const (
	USD = "USD"
	UZS = "UZS"
	EUR = "EUR"
)

func IsSupportedCurrency(currency string) bool {
	switch currency {
	case USD, UZS, EUR:
		return true
	}

	return false
}
