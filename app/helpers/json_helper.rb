Linked4::App.helpers do
  def _j
    @json = ::MultiJson.decode(request.body).symbolize_keys! if @json.nil? #lazy init to it doesn't get overhead
    @json
  end
end

