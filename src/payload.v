module jwt

import time

pub struct Payload {
	iss ?string // issuer; usually the domain name of the application issuing the token
	sub ?string // subject; usually the id of the user the token represents
	aud ?string // audience; usually the domain name of the application that will receive the token
	exp ?time.Time // expiration time; unix timestamp
	iat ?time.Time // not before; unix timestamp
	ext ?string // extra data
}
