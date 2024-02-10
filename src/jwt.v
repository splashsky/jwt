module jwt

import encoding.base64
import x.json2 as json
import crypto.hmac
import crypto.sha256
import time

pub struct Token[T] {
	header    string
	signature string
pub:
	payload Payload[T]
}

pub fn Token.new[T](payload Payload[T], secret string) Token[T] {
	header := base64.url_encode(json.encode[Header](Header{}).bytes())
	payload_string := base64.url_encode(json.encode(payload).bytes())

	signature := base64.url_encode(hmac.new(secret.bytes(), '${header}.${payload_string}'.bytes(),
		sha256.sum, sha256.block_size).bytestr().bytes())

	return Token[T]{
		header: header
		payload: payload
		signature: signature
	}
}

pub fn from_str[T](token string) !Token[T] {
	parts := token.split('.')
	if parts.len != 3 {
		return error('Invalid token')
	}

	return Token[T]{
		header: parts[0]
		payload: json.decode[Payload[T]](base64.url_decode_str(parts[1]))!
		signature: parts[2]
	}
}

pub fn (t Token[T]) str() string {
	payload := base64.url_encode(json.encode(t.payload).bytes())
	return t.header + '.' + payload + '.' + t.signature
}

pub fn (t Token[T]) valid(secret string) bool {
	if t.expired() {
		return false
	}

	parts := t.str().split('.')
	if parts.len != 3 {
		return false
	}

	expected_signature := base64.url_encode(hmac.new(secret.bytes(), '${parts[0]}.${parts[1]}'.bytes(), // header + payload
	 sha256.sum, sha256.block_size).bytestr().bytes())

	return parts[2] == expected_signature // signature == expected_signature
}

pub fn (t Token[T]) expired() bool {
	return t.payload.exp or { return false } < time.now()
}
