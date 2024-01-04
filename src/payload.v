module jwt

import time

pub struct Payload {
	iss ?string @[omitempty]
	sub ?string @[omitempty]
	aud ?string @[omitempty]
	exp ?time.Time @[omitempty]
	iat ?time.Time @[omitempty]
	ext ?string @[omitempty]
}
