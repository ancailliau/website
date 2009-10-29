module AcmScW
  module Services
    class Subscribe
      
      def create_db_connection
        begin
          # No connection previously created, or trying a new one
          @connection = PGconn.open(:host => 'localhost', 
                                    :dbname => 'acmscw', 
                                    :user => 'acmscw', 
                                    :password => 'acmscw')
          @connection.set_client_encoding('utf8')
          return @connection
        rescue PGError => ex
          # Fatal case, no connection can be created (is PostgreSQL running?)
          raise ex
        end
      end
      
      def db_connection
        @connection ||= create_db_connection
      end
      
      def insert_mail(mail)
        conn = db_connection
        mail = conn.escape_string(mail)
        sql = "INSERT INTO \"NEWS_SUBSCRIPTIONS\" (\"mail\")"\
        "  SELECT '#{mail}' as \"mail\" WHERE NOT EXISTS"\
        "    (SELECT * FROM \"NEWS_SUBSCRIPTIONS\" WHERE \"mail\"='#{mail}')"
        puts sql
        db_connection.exec(sql)
      end
      
      def ok
        {:error_code => 0, :msg => "OK"}
      end
      
      def error(code, msg)
        {:error_code => code, :msg => msg}
      end
      
      # Send a final result
      def result(http_code, result)
        [http_code, {'Content-Type' => 'application/json'}, result]
      end
      
      def call(env)
        request = Rack::Request.new(env)
        if request.post? and request['mail']
          mail = request['mail']
          if mail =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
            begin
              insert_mail(mail)
            rescue PGError => ex
              puts "WARNING, unable to insert mail #{ex.message}"
              return result(500, error(601, 'Access to database failed'))
            end
            return result(200, ok)
          else
            return result(412, error(1, "Doesn't looks like a valid mail address"))
          end
        else
          return result(417, error(600, "POST request expected, containing a mail parameter"))
        end
      end
    
    end
  end
end