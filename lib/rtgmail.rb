require 'gmail'

module RtGmail
  class Client
    attr_accessor :gmail
    def initialize(username, password)
      self.gmail = Gmail.new(username, password)
      #@new = self.gmail.emails.last.message
      return self.gmail
    end

    def stream
      loop do
        self.gmail.inbox.emails(:unread).each do |email|

        end
        sleep 5
      end
    end

    def method_missing(method, *args)
      p "self.gmail.#{method}(#{build_args(args)})"
      eval "self.gmail.#{method}(#{build_args(args)})"
    end
    
    private
    def build_args(args)
      args.map{|item| "'#{item}'" }.join(" ")
    end
  end

  class Mail
    attr_accessor :mail, :message
    def initialize(mail, message)
      self.mail = mail
      self.message = message
    end

    def reply(text)

    end
  end
end