class ImportController < ApplicationController
  
  #インポート画面の表示
  def importcsv
  end
  
  #CSVファイルのインポート
  def action
    
    if params[:csv_file].blank?
      redirect_to("/import/importcsv", alert: 'インポートするCSVファイルを選択してください')
    else
      extension = params[:csv_file].path.slice(-3,3)
      if(extension != "csv")
        redirect_to("/import/importcsv", alert: 'インポートするCSVファイルを選択してください')
      else
        @@items = Importuser.import(params[:csv_file])
      end
      
      #for userinfo in @@items
      #  username = userinfo["ユーザー名"]
      #  userno = userinfo["社員番号"]
      #end
    end
  end
  
  #アクセストークンを返す
  def getItems
    return @@items
  end
  
end
