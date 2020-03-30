require 'date'

namespace :cron do
  task ten_minutely: :environment do
    Shop.sync!
  end
end
