module jwt

import json

fn test_jwt() {
	key := "secret"
	claims := {"name": "John Doe", "admin": "true"}
	payload := Payload{
		sub: "1234567890",
		ext: json.encode(claims)
	}
	token := Token.new(payload, key)

	// Verify token
	verified := token.verify(key)
	assert verified == true
	assert token.expired() == false
}
