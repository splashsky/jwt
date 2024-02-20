# JWT
A simple, self-contained module for making and verifying JWTs using HMAC SHA256. Built to be simple!

## Example
```v
import jwt

const secret = 'secret-key'

pub struct Credential {
	user string
	pass string
}

fn main() {
	// Create a new token
	payload := jwt.Payload[Credential]{
		sub: '1234567890'
		ext: Credential{
			user: 'splashsky'
			pass: 'password'
		}
	}
	token := jwt.Token.new(payload, secret)
	receive_token_from_web := token.str()

	// Validate a token from the web
	obj_token := jwt.from_str[Credential](receive_token_from_web)!
	if obj_token.valid(secret) {
		println('token valid!')
		dump(obj_token.payload.ext)
	}
}
```
