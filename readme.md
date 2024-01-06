# JWT
A simple, self-contained module for making and verifying JWTs using HMAC SHA256. Built to be simple!

## Example
```v
import jwt
import json

const secret := "secret-key"

// Create a new token
payload := jwt.Payload{
    sub: "1234567890",
    ext: json.encode(/* some struct */)
}
token := jwt.Token.new(payload, secret)
respond_with(token.str())

// Validate a token from the web
token := jwt.Token.from_str(/* receive a token from the web */)
if token.valid(secret) {
    // do stuff
}
```
