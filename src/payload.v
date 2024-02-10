module jwt

import time

pub struct Payload[T] {
	iss ?string    @[omitempty]
	sub ?string    @[omitempty]
	aud ?string    @[omitempty]
	exp ?time.Time @[omitempty]
	iat ?time.Time @[omitempty]
pub:
	ext T @[omitempty]
}
