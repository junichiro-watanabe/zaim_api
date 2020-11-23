require 'erb'
require 'oauth'
require 'cgi'
require 'cgi/session'
require 'json'

##### ユーザ固有情報を格納してください ###########################################################
# zaim へのアプリケーション登録後に発行されるコンシューマ ID
consumer_key = "<input your consumer_key>"
# zaim へのアプリケーション登録後に発行されるコンシューマシークレット ID
consumer_secret = "<input your consumer_secret>"
# zaim での認証後のコールバック先 URL
callback_url = "<input your callback_url>"
###############################################################################################

# Zaim API 情報格納する
site = 'https://api.zaim.net'                             # ルート URL
provider_base = 'https://api.zaim.net/v2/auth/'           # OAuth ベース URL
request_url = "#{provider_base}request"                   # request token リクエスト URL
authorize_url = "https://auth.zaim.net/users/auth"        # 認証 URL
access_url = "#{provider_base}access"                     # access token リクエスト URL
resource_url = 'https://api.zaim.net/v2/home/user/verify' # アクセス先 URL

# OAuth Consumer インスタンスを生成
oauth_consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
                                     site: site,
                                     request_token_url: request_url,
                                     authorize_url: authorize_url,
                                     access_token_url: access_url)

# CGIインスタンス生成
cgi = CGI.new
session = CGI::Session.new(cgi)

# セッションクリア処理
if !cgi.params['action'].empty? && \
   cgi.params['action'][0] == 'clear'

  session = CGI::Session.new(cgi, { "new_session" => true })
end

# 結果表示部分
@content = ''

# 処理開始
begin
  # ２．認証処理(初回は session['type'] = nil のため実行されない)
  if session['type'] == 'authorize' && \
     !cgi.params['oauth_token'][0].nil? && \
     !cgi.params['oauth_verifier'][0].nil?

    request_token = OAuth::RequestToken.new(oauth_consumer, session['oauth_token'], session['oauth_token_secret'])
    access_token = request_token.get_access_token(oauth_verifier: cgi.params['oauth_verifier'][0])
    session['type'] = 'access'
    session['oauth_token'] = access_token.token
    session['oauth_token_secret'] = access_token.secret
  end

  # ３．アクセス処理(初回は session['type'] = nil のため実行されない)
  if session['type'] == 'access'
    access_token = OAuth::AccessToken.new(oauth_consumer, session['oauth_token'], session['oauth_token_secret'])
    response = access_token.get(resource_url)
    @content = JSON.parse(response.body)

  # １．token リクエスト処理
  elsif session['type'].nil?
    request_token = oauth_consumer.get_request_token(oauth_callback: callback_url)
    session['type'] = 'authorize'
    session['oauth_token'] = request_token.token
    session['oauth_token_secret'] = request_token.secret
    authorize_url = request_token.authorize_url(oauth_callback: callback_url)
    @content = "Click the link.<br />"
    @content += "<a href=#{authorize_url}>#{authorize_url}</a>"
  end

# 例外処理
rescue StandardError => e
  @content = e.message
end

# html生成
erb = ERB.new(File.read("./sample_code.html.erb"))
html = erb.result(binding)
puts html
