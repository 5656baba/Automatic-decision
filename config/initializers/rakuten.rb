RakutenWebService.configure do |c|
  # (必須) アプリケーションID
  c.application_id = ENV['YOUR_APPLICATION_ID']

  # (任意) 楽天アフィリエイトID
  c.affiliate_id = ENV['YOUR_AFFILIATE_ID']
end