require 'api/tweet_stream_helper'

namespace :twitter do
  desc "Start tweet stream listeners for each movie in the db"
  task :import_sentiment => :environment do

    current_movies = Movie.all
    current_movies.each do |movie|
        twitter_stream_capture = Api::TweetStremHelper.new
        twitter_stream_capture.start_twitter_stream_listener(movie.title)
    end
  end

  desc "Migrate sentiment from redis to sql db (using model)"
  task :migrate_sentiment => :environment do
    require 'db/movie_tracker_redis'
    movie_tracker = Db::MovieTrackerRedis.new

    current_movies = Movie.all
    current_movies.each do |movie|
        movie.sentiment = movie_tracker.movie_rating(movie.title)
        movie.save
    end
  end
end
