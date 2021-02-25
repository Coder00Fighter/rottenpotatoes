class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings)
    query_string = "rating = " + "'#{ratings[0]}'"
    for i in 1..(ratings.length() - 1)
      query_string << " OR rating = " + "'#{ratings[i]}'"
    end
    print query_string
    return self.where(query_string)
  end
end
