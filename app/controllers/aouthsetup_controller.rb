class AouthsetupController < ApplicationController
  
require 'http'
CTX = OpenSSL::SSL::SSLContext.new
CTX.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
  #トップページ（入力画面）
  def setup
  end
  
  #入力値の受取り画面
  def getcode
    
    #Veiwから値を受取る
    @@key = 	params[:email].presence
    @@client =	params[:clientId].presence
    @@secret =	params[:clientSecret].presence
    @@deviceId =	params[:deviceId].presence
    #@@callbackuri = 'https://import-user-yumikotsunai.c9users.io/aouthsetup/callback'
    @@callbackuri = 'https://importusers.herokuapp.com/aouthsetup/callback'
    
    #connectのoauth認証のためのURLにアクセスする  (A)リソースオーナーにAuthorization Request送信
    req = 'https://connect.lockstate.jp/oauth/'+'authorize?'+'client_id='+@@client+'&response_type=code&redirect_uri='+@@callbackuri
    
    redirect_to req
    
  end
  
  #認証コードの受取りとトークンの発行
  def callback
    
    #(B)リソースオーナーからAuthorization Grant受取り
    code = params[:code]
    
    #(C)認可サーバーにAuthorization Grant送信
    postform = {'code' => code \
    ,'client_id' => @@client \
    ,'client_secret' => @@secret \
    ,'redirect_uri' => @@callbackuri\
    ,'grant_type' => 'authorization_code' }
    
    res = HTTP.headers("Content-Type" => "application/x-www-form-urlencoded")
    .post("https://connect.lockstate.jp/oauth/token", :ssl_context => CTX , :form => postform)

    #(D)認可サーバーからレスポンス（アクセストークン）受取り
    #認証失敗の場合
    if res.code!=200
      @error = res
      @state = "認証に失敗しました"
      render
    #認証成功の場合
    else
      @error = res
      @state = "認証に成功しました"
      json = ActiveSupport::JSON.decode( res.body )
      puts(json)
      
      #アクセストークン
      @@accessToken = json["access_token"]
      puts(@@accessToken)
      render
    end
  end
  
  #アクセストークンを返す
  def getAccessToken
    return @@accessToken
  end
  
  #デバイスIDを返す
  def getDeviceId
    return @@deviceId
  end
  
end