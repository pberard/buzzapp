require 'sinatra'
require './yelpConfig.rb'
require './twitterConfig.rb'
require './helpers.rb'

enable :logging

configure do 
	@@twitterclient = getTwitterClient()
	@@yelpclient = getYelpClient()
	@@restaurants = getRestaurantTuples()
end

get '/' do 	
	@names = []
	@@restaurants.each do |restaurant|
		nameResponse = @@yelpclient.business(restaurant.yelpID)
		@names.push(nameResponse.business.name)
	end
	erb :home
end

get '/bieber' do
	biebs = ""
	@@twitterclient.search("to:justinbieber marry me", result_type: "recent").take(3).collect do |tweet|
		biebs += "#{tweet.user.screen_name}: #{tweet.text}"
	end
	return biebs
end


get '/cheese' do
	tweets = ""
	@@twitterclient.search("to:CheesiesChicago OR from:CheesiesChicago", result_type: "recent,mixed").take(3).collect do |tweet|
		tweets += "#{tweet.user.screen_name}: #{tweet.text}<br>"
	end
	return tweets
end

get '/getYelpID' do
	parms = {
		category_filter: 'restaurants', 
		term: "bar on buena", #This is how I'm getting the yelp ID. Quick and dirty for a quick and clean project.
		limit: 10,
		sort: 0
	} 
	retval = ""
	response = @@yelpclient.search("chicago", parms)
	response.businesses.each do |biz| 
		retval += biz.name + "<br>"
		retval += biz.id.to_s + "<br>"
		retval +=  "--------------------------------------------" + "<br>"
	end
	return retval
end

get '/buzz/:restaurantIndex' do
	#There currently isn't a field in Yelp for a twitter handle. So this is the part I hard code and hope someday Yelp changes.
	#It would also be cool to aggregate an association between twitter handles and yelp ids. Maybe add in facebook, a link to their website...
	restaurant = @@restaurants[params['restaurantIndex'].to_i]
	
	#Get yelp info
	@yelpResponse = @@yelpclient.business(restaurant.yelpID)
	#Get tweets
	twitterResponse = @@twitterclient.search(restaurant.twitterHandle, result_type: "recent", count: 100)

	@hotTopics = getMostCommonHashtags(twitterResponse)
	puts @hotTopics.to_s

	@recentTweets = twitterResponse.take(10)



	#Cool part, how do we filter the tweets for interesting stuff?
	#Tweets about the most popular items on the menu?
	#Tweets in response to the restaurant?
	#Common hashtags?

	erb :buzz
end