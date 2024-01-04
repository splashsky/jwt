# JWT
A simple, self-contained module for making and verifying JWTs using HMAC SHA256. Built to be simple!

## Example
```v
import jwt
import json

key := "secret-key"

payload := Payload{
    sub: "1234567890",
    ext: json.encode(/* some struct */)
}
token := Token.new(payload, key)

verified := token.verify(key)
```
