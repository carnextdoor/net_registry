require "net/http"

module NetRegistry
  class Client

    attr_accessor :merchant, :password
    attr_accessor :base_url

    def initialize(merchant = ENV["NET_REGISTRY_MERCHANT"], password = ENV["NET_REGISTRY_PASSWORD"])
      @merchant, @password = merchant, password
      @base_url = "https://paygate.ssllock.net/external2.pl"
    end

    # args: hash with the following keys (in symbol)
    # AMOUNT: The nominal amount of the transaction. e.g. 100.0
    # CCNUM:  Credit card number
    # CCEXP:  Credit card expiry date in format of mm/yy
    # COMMENT: (optional) Comments for this transaction
    def purchase(params = {})
      raise TypeError if !params.is_a?(Hash)
      params = process_hash(params).merge(LOGIN:   "#{@merchant}/#{@password}",
                                          COMMAND: "purchase")
      net_response = NetRegistry::ResponseFactory.create("purchase", params)
      return net_response if net_response.failed?

      uri = URI(@base_url)
      res = Net::HTTP.post_form(uri, params)
      net_response.parse(res.body)
    end

    def refund(params = {})
      raise TypeError if !params.is_a?(Hash)
      params = process_hash(params).merge(LOGIN:   "#{@merchant}/#{@password}",
                                          COMMAND: "refund")
      net_response = NetRegistry::ResponseFactory.create("refund", params)
      return net_response if net_response.failed?

      uri = URI(@base_url)
      res = Net::HTTP.post_form(uri, params)
      net_response.parse(res.body)
    end

    def status(params = {})
      raise TypeError if !params.is_a?(Hash)
      params = process_hash(params).merge(LOGIN:   "#{@merchant}/#{@password}",
                                          COMMAND: "status")
      net_response = NetRegistry::ResponseFactory.create("refund", params)
      uri = URI(@base_url)
      res = Net::HTTP.post_form(uri, params)
      net_response.parse(res.body)
    end

    def preauth(card_number, card_expiry, amount, ccv = nil, comment = "")
      raise TypeError if !params.is_a?(Hash)
      params = process_hash(params).merge(LOGIN:   "#{@merchant}/#{@password}",
                                          COMMAND: "preauth")
      net_response = NetRegistry::ResponseFactory.create("preauth", params)
      uri = URI(@base_url)
      res = Net::HTTP.post_form(uri, params)
      net_response.parse(res.body)
    end

    private

    def process_hash(hash)
      hash.each { |key, value| hash[key] = value.to_s }
    end

  end
end
