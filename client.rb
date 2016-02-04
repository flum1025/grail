path = File.expand_path('../', __FILE__)
require File.join(path, 'lib', 'rtgmail.rb')

username = 'user_name'
password = 'password'

rg = RtGmail::Client.new(username, password)
rg.stream do |mail| #ストリームもどき デフォルトだと20秒ごとに未読メールを取得
  mail.reply('subject', 'body', 'sender_name')
end
#rg.send_mail('hoge@hoge.fuga.jp','subject', 'body', 'sender_name') #指定の相手にメールを送信

