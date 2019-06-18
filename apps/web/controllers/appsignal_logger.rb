module AppsignalLogger

  def call(params)
    return super(params) if Hanami.env == 'test'

    @_request = ::Rack::Request.new(@_env)
    Appsignal::Transaction.create(
      SecureRandom.uuid,
      Appsignal::Transaction::HTTP_REQUEST,
      @_request
    )

    begin
      Appsignal.instrument("process_action.hanami") do
        super params
      end
    rescue Exception => e
      Appsignal::Transaction.current.set_error(e)
      raise e
    ensure
      Appsignal::Transaction.current.set_action_if_nil(self.class.name)
      Appsignal::Transaction.current.set_metadata("path", @_request.path)
      Appsignal::Transaction.current.set_metadata("method", @_request.request_method)
      Appsignal::Transaction.current.params = params.to_h
      Appsignal::Transaction.current.set_http_or_background_queue_start
      Appsignal::Transaction.complete_current!
    end
  end
end
