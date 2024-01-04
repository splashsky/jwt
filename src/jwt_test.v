module jwt

import x.json2 as json
import time

const secret := "secret"
const claims := {"name": "John Doe", "admin": "true"}

fn test_valid() {
	payload := Payload{
		sub: "1234567890",
		ext: json.encode(claims)
	}
	token := Token.new(payload, secret)

	assert token.valid(secret) == true
}

fn test_expired() {
	payload := Payload{
		sub: "1234567890",
		ext: json.encode(claims),
		exp: time.parse("2019-01-01 00:00:00") or { panic(err) }
	}
	token := Token.new(payload, secret)

	assert token.expired() == true
	assert token.valid(secret) == false
}

fn test_from_str() {
	payload := Payload{
		sub: "1234567890",
		ext: json.encode(claims)
	}
	payload2 := Payload{
		sub: "0987654321",
		ext: json.encode(claims)
	}

	token := Token.new(payload, secret)
	token2 := Token.from_str(token.str())!
	token3 := Token.new(payload2, secret)

	assert token2 == token
	assert token2 != token3
}
