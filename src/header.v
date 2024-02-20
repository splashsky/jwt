module jwt

pub struct Header {
	alg string = 'HS256'
	typ string = 'JWT'
}
