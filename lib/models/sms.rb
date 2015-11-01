module EStore
  class SMS
    include DataMapper::Resource

    property :id, Serial

    property :client_ip, IPAddress, required: true
    property :phone, String, required: true, :format => /^1\d{10}$/, length: 11
    property :code, String, required: true, :format => /^\d{6}$/, length: 6

    property :created_at, DateTime
  end
end