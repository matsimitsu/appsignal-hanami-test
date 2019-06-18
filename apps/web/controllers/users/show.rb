module Web
  module Controllers
    module Users
      class Show
        include Web::Action

        def call(params)
          raise "An error occurred"
        end
      end
    end
  end
end
