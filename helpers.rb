IDTuple = Struct.new(:twitterHandle, :yelpID)
#@fatcat = IDTuple.new('@FatCatChicago', 'fat-cat-chicago')
#@fatcat.twitterHandle = '@FatCatChicago'
#@fatcat.yelpID = 'fat-cat-chicago'

def isNilOrEmpty?(x)
	if (x.nil? || x.empty?)
		return true
	end
	return false
end
#Is it bad to hardcode? Yes. Am I doing it here? Yes. I'm a naughty programmer.  Bad bad bad. https://www.youtube.com/watch?v=QvwDohEEQ1E
def getRestaurantTuples()
	@cheesies = IDTuple.new('@CheesiesChicago', 'cheesies-pub-and-grub-chicago')
	@niusushi = IDTuple.new('@SushiNiu','niu-japanese-fusion-lounge-chicago')
	@bob = IDTuple.new('@thebaronbuena','bar-on-buena-chicago')
	#@michaels = IDTuple.new('','michaels-pizzeria-and-tavern-chicago-2') #Now here's a business thats not on twitter yet. Womp womp.
	@polkstreet = IDTuple.new('@PolkPub', 'polk-street-pub-chicago')
	@fatcat = IDTuple.new('@FatCatChicago', 'fat-cat-chicago')
	return [@cheesies, @niusushi, @bob, @polkstreet, @fatcat]
end

def getMostCommonHashtags(twitterResponse)
	puts "Start of getMostCommonHashtags"
	
	hotTags = Array.new
	hashTags = Hash.new(0) #Default the value to 0 so that we can count the occurence of each hashtag easily

	twitterResponse.each do |tweet|
		tweet["hashtags"].each do |hashtag|
			hashTags[hashtag.text] = hashTags[hashtag.text] + 1
		end
	end

	if(!hashTags.nil? && hashTags.length > 0 )then
		highestOccurences = hashTags.values.sort { |x,y| y <=> x }
		#We're just going to take the 5 most common values
		highestOccurences = highestOccurences.take(if highestOccurences.length > 5 then 5 else highestOccurences.length end)
		#and use the lowest value to filter out the keys!
		lowestOfHighestOccurenceRate = highestOccurences.min
		hotTags = (hashTags.select {|k,v| v >= lowestOfHighestOccurenceRate}).keys
	else
		#womp womp no hashtags
		hotTags.push("No hashtags! How lame!")
	end
	puts "End of getMostCommonHashtags"
	return hotTags
end