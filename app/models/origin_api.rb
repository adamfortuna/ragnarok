class OriginApi

  def self.options
    {
      headers: {
        'x-api-key': ENV['ORIGIN_API_KEY']
      }
    }
  end

  def self.ping
    HTTParty.get("#{ENV['ORIGIN_API_URL']}/ping", options).parsed_response
  end

  def self.items
    HTTParty.get("#{ENV['ORIGIN_API_URL']}/items/list", options).parsed_response['items']
  end

  def self.icons
    HTTParty.get("#{ENV['ORIGIN_API_URL']}/items/icons", options).parsed_response['icons']
  end

  def self.shops
    HTTParty.get("#{ENV['ORIGIN_API_URL']}/market/list", options).parsed_response['shops']
  end
end
