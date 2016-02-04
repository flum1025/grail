require 'gmail'

module Grail
  class Client
    attr_accessor :gmail
    def initialize(username, password)
      self.gmail = Gmail.new(username, password)
      #@new = self.gmail.inbox.emails.last.message.message_id
    end

    def stream(freq=20)
      loop do
        self.gmail.inbox.emails(:unread).each do |email|
          begin
            next if email.message.from.include?("mailer-daemon@googlemail.com")
            yield Mail.new(self.gmail, email)
          rescue => e
            p e.class
            p e.message
            email.mark(:unread)
          end
        end
        sleep freq
        self.gmail.disconnect #一旦切断しないと新しいメールを取得してくれない 更新するメソッドとかありそうだけどとりあえずやっつけで
        self.gmail = Gmail.new(self.gmail.send(:meta).username, self.gmail.send(:meta).password)
      end
    end

    def latest
      Mail.new(self.gmail, self.gmail.inbox.emails.last)
    end
    
    def send_mail(addr, subject, text, from=nil)
      message = self.gmail.generate_message do
        from from
        to addr
        subject subject
        text_part do
          body text
        end
      end
      self.gmail.deliver(message)
    end

    def method_missing(method, *args)
      eval "self.gmail.#{method}(#{build_args(args)})"
    end

    private

    def build_args(args)
      args.map{|item| "'#{item}'" }.join(" ")
    end
  end

  class Mail
    attr_accessor :gmail, :mail, :message
    def initialize(gmail, mail)
      self.gmail = gmail
      self.mail = mail
      self.message = mail.message.text_part.decoded
    end

    def reply(subject, text, from=nil)
      to = self.mail.message.from
      message = self.gmail.generate_message do
        from from
        to to
        subject subject
        text_part do
          body text
        end
      end
      self.gmail.deliver(message)
    end
  end
end