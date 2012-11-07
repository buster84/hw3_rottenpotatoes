class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  def self.find_all_with_same_director( movie )
    same_directors = Movie.find_all_by_director(movie.director)
    i = 0
    same_directors.each do |m|
      if m.id == movie.id
        same_directors.slice!(i, 1)
        break
      end
      i += 1
    end
    return same_directors
  end
end
