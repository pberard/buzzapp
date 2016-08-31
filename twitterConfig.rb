require 'twitter'

@twitterclient = Twitter::REST::Client.new do |config|
	config.consumer_key        = "FNfMTyfrBWs5syHfmy1Qj3Abh"
	config.consumer_secret     = "EcwD1Y3mB95N5FlMgJpM8K13LP2Fb1GAiqwCKPHwKTg47aZqsR"
	config.access_token        = "2248877880-pGFUBpO9Udof1Dv0eYkm0tmmXovRhhw3HL0cJlS"
	config.access_token_secret = "8PJ7VNbvdVIECKtXtA5rK5J6aa7IhnxqAo0Wuj59aOQYl"
end
def getTwitterClient()
	return @twitterclient
end
