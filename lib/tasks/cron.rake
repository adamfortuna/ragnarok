require 'date'

namespace :cron do
  task ten_minutely: :environment do
    Shop.sync!
    Item.best_prices!
  end
end
