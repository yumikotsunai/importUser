class CallapiController < ApplicationController
  
require 'http'
require 'csv'
CTX = OpenSSL::SSL::SSLContext.new
CTX.verify_mode = OpenSSL::SSL::VERIFY_NONE

  #アクセスユーザーの作成
  def getaccessuser
    
    #AouthsetupControllerクラスからアクセストークンを取得
    aouthctr = AouthsetupController.new
    accessToken = aouthctr.getAccessToken
    
    #ImportControllerクラスからインポートデータを取得
    importctr = ImportController.new
    items = importctr.getItems
    
    @successList = []
    @errorList = []
    for user in items
    
      puts("アクセスユーザー作成")
      name = user["ユーザー名"]
      pin = user["社員番号"]
      
      postbody1 = {
        "type": "access_user",
        "attributes": {
          "name": name,
          "pin": pin,
        }
      }
      authtoken = "Bearer "+ accessToken
      res1 = HTTP.headers("Content-Type" => "application/json",:Authorization => authtoken )
      .post("https://api.lockstate.jp/access_persons", :ssl_context => CTX , :body => postbody1.to_json)
      
      if res1.code == 201
        j = ActiveSupport::JSON.decode(res1.body)
        data = j["data"]
        userId = data["id"]
        
        puts("アクセスゲストにロック権限を追加")
        deviceId = aouthctr.getDeviceId
        
        postbody2 = {
          "attributes": {
            "accessible_id": deviceId,
            "accessible_type": "lock",
          }
        }
        authtoken = "Bearer "+ accessToken
        apiUri = "https://api.lockstate.jp/access_persons/" + userId + "/accesses"
        
        res2 = HTTP.headers("Content-Type" => "application/json",:Authorization => authtoken)
        .post(apiUri, :ssl_context => CTX , :body => postbody2.to_json)
        
      end
      
      if res1.code == 201 and res2.code == 201
        @successList.push(name + "," + pin)
      else
        @errorList.push(name + "," + pin)
      end
      
    end
    
  end
  
end
