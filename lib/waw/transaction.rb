module Waw
  # Encapsulates a transaction to a database and provide utilities
  class Transaction
    
    # A relation variable
    class Relvar
      
      # Initializes the relvar
      def initialize(transaction, conn, name)
        @transaction, @conn, @name = transaction, conn, name
      end
      
      # Converts a hash to an insert into statement
      def hash_to_insert_into(hash)
        values = hash.keys.sort{|k1, k2| k1.to_s <=> k2.to_s}.collect{|v| "'#{@conn.escape_string(hash[v])}'"}
        <<-EOF
          INSERT INTO "#{@name}" ("#{hash.keys.sort{|k1, k2| k1.to_s <=> k2.to_s}.join('", "')}")
          VALUES (#{values.join(', ')});
        EOF
      end
      
      # Converts an array of tuples to insert statements
      def array_to_insert_into(tuples)
        tuples.collect{|t| hash_to_insert_into(t)}.join("\n")
      end
      
      # Inserts tuples inside the relation variable
      def <<(tuples)
        case tuples
          when Array
            sql = array_to_insert_into(tuples)
          when Hash
            sql = hash_to_insert_into(tuples)
          else 
            raise "Invalid tuples argument #{tuples}"
        end
        puts sql
        @conn.exec(sql)
      end
      
    end # class Relvar
    
    # Initializes the transaction with a given connection
    def initialize(conn)
      @conn = conn
    end
    
    # Executes the block transactionnaly
    def go!
      raise "Transaction already ended" unless @conn
      yield self
    ensure
      @conn.close
      @conn = nil
    end
    
    # Provides access to relation variables
    def method_missing(name, *args)
      if name.to_s =~ /[A-Z_]+/
        Relvar.new(self, @conn, name)
      else
        super
      end
    end
    
  end # class Transaction
end # module Waw