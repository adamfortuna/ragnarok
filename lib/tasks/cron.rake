require 'date'

namespace :cron do
  task weekly: :environment do
    if Date.today.wday == 1
      Item.sync!
    end
  end

  task ten_minutely: :environment do
    Shop.sync!
  end

  task hourly: :environment do
    Item.best_prices!
  end
end
