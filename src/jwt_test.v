module jwt

import time

const no_secret = 'pass secret'
const secret = 'secret'
const claims = {
	'name':  'John Doe'
	'admin': 'true'
}

fn test_valid() {
	payload := Payload[map[string]string]{
		sub: '1234567890'
		ext: jwt.claims
	}
	token := Token.new(payload, jwt.secret)

	assert token.valid(jwt.secret)
}

fn test_invalid() {
	payload := Payload[map[string]string]{
		sub: '1234567890'
		ext: jwt.claims
	}
	token := Token.new(payload, jwt.secret)

	assert !token.valid(jwt.no_secret)
}

fn test_expired() {
	payload := Payload[map[string]string]{
		sub: '1234567890'
		ext: jwt.claims
		exp: time.parse('2019-01-01 00:00:00') or { panic(err) }
	}
	token := Token.new(payload, jwt.secret)

	assert !token.valid(jwt.secret)
	assert token.expired()
}

fn test_no_expired() {
	payload := Payload[map[string]string]{
		sub: '1234567890'
		ext: jwt.claims
		exp: time.now().add_seconds(10)
	}
	token := Token.new(payload, jwt.secret)

	assert token.valid(jwt.secret)
	assert !token.expired()
}

fn test_from_str() {
	payload := Payload[map[string]string]{
		sub: '1234567890'
		ext: jwt.claims
	}
	payload2 := Payload[map[string]string]{
		sub: '0987654321'
		ext: jwt.claims
	}

	token := Token.new(payload, jwt.secret)
	token2 := from_str[map[string]string](token.str())!
	token3 := Token.new(payload2, jwt.secret)

	// error compiler
	// assert token2 == token
	// assert token2 != token3
}
