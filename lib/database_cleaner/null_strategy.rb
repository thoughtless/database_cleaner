module DatabaseCleaner
  class NullStrategy
    def self.start
      # no-op
    end

     def self.db=(connection)
       # no-op
     end

     def self.model=(connection)
       # no-op
     end

    def self.clean
      # no-op
    end
  end
end
