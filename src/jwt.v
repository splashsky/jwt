module jwt

import encoding.base64
import x.json2 as json
import crypto.hmac
import crypto.sha256
import time

pub struct Token {
	header string
	payload string
	signature string
}

pub fn Token.new(payload Payload, secret string) Token {
	header := base64.url_encode(json.encode[Header](Header{}).bytes())
	payload_string := base64.url_encode(json.encode[Payload](payload).bytes())
	signature := base64.url_encode(hmac.new(
		secret.bytes(),
		"${header}.${payload_string}".bytes(),
		sha256.sum,
		sha256.block_size
	).bytestr().bytes())

	return Token{
		header: header,
		payload: payload_string,
		signature: signature,
	}
}

pub fn (t Token) to_string() string {
	return t.header + "." + t.payload + "." + t.signature
}

pub fn (t Token) verify(secret string) bool {
	parts := t.to_string().split(".")
	if parts.len != 3 {
		return false
	}

	expected_signature := base64.url_encode(hmac.new(
		secret.bytes(),
		"${parts[0]}.${parts[1]}".bytes(), // header + payload
		sha256.sum,
		sha256.block_size
	).bytestr().bytes())

	return parts[2] == expected_signature // signature == expected_signature
}

pub fn (t Token) payload() !Payload {
	return json.decode[Payload](base64.url_decode(t.payload).str())!
}

pub fn (t Token) expired() bool {
	payload := t.payload() or { return false }

	if payload.exp == none {
		return false
	}

	exp := payload.exp

	if exp < time.now() {
		return true
	} else {
		return false
	}
}
