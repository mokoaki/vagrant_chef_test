class WelcomeController < ActionController::Base
  def index
    @user = User.first

    @redis_test_data = Rails.cache.fetch('temp_key', expires_in: 10.seconds) do
      sleep 3
      'この文字列はredisに入っていたデータです。キャッシュが無ければ3秒待ってキャッシュを作るようになっています。このredisのキャッシュは10秒間だけ有効です。つまり10秒以内なら、次回はキャッシュから高速に返答するはずです。'
    end
  end
end
