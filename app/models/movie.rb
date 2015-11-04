class Movie < ActiveRecord::Base
   @@all_ratings = ["G", "PG-13", "R", "PG"]
   def self.all_ratings
     allRatings = []
     Movie.all.each do |movie|
       if (allRatings.find_index(movie.rating) == nil)
         allRatings.push(movie.rating)
       end
     end
     return allRatings
   end
end