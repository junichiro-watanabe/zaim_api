require 'erb'
require 'oauth'
require 'cgi'
require 'cgi/session'

##### ユーザ固有情報を格納してください ###################################################
consumer_key = "0ee0e839a43ec6c737070875125ca168da422175"     # コンシューマ ID
consumer_secret = "b6e4eab08dc3e923cfc0eea342e56415c34c3814"  # コンシューマシークレット
callback_url = 'http://localhost:3000'                        # コールバック先URL
########################################################################################

# Zaim API 情報格納する
site = 'https://api.zaim.net' # ルートパス
provider_base = 'https://api.zaim.net/v2/auth/'           # OAuth ベースパス
request_url = "#{provider_base}request"                   # request token リクエストパス
authorize_url = "https://auth.zaim.net/users/auth"        # 認証 パス
access_url = "#{provider_base}access"                     # access token リクエストパス
resource_url = 'https://api.zaim.net/v2/home/user/verify' # リソースパス

# OAuth Consumer インスタンスを生成
oauth_consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
                                     site: site,
                                     request_token_url: request_url,
                                     authorize_url: authorize_url,
                                     access_token_url: access_url)

# 結果表示部分
@content = ''

# CGIインスタンス生成
cgi = CGI.new
session = CGI::Session.new(cgi)

# ２．認証処理
session['type'] = 'access' if session['type'] == 'authorize'

# ３．アクセス処理
if session['type'] == 'access'
  @content = 'accessed'

# １．token リクエスト処理
else
  session['type'] = 'authorize'
  @content = 'created token'
end

# html生成
erb = ERB.new(File.read("./sample_code.html.erb"))
html = erb.result(binding)
puts cgi.header
puts html
