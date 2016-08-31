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

get '/buzz/:restaurantIndex' do
	#There currently isn't a field in Yelp for a twitter handle. So this is the part I hard code and hope someday Yelp changes.
	#It would also be cool to aggregate an association between twitter handles and yelp ids. Maybe add in facebook, a link to their website...
	restaurant = @@restaurants[params['restaurantIndex'].to_i]
	
	#Get yelp info
	@yelpResponse = @@yelpclient.business(restaurant.yelpID)
	#Get tweets
	twitterResponse = @@twitterclient.search(restaurant.twitterHandle, result_type: "recent", count: 100)

	@hotTopics = getMostCommonHashtags(twitterResponse)

	@recentTweets = twitterResponse.take(10)

	#Cool part, how do we filter the tweets for interesting stuff?
	#Tweets about the most popular items on the menu?
	#Tweets in response to the restaurant?
	#Common hashtags?

	erb :buzz
end