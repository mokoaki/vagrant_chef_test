class WelcomeController < ActionController::Base
  def index
    @user = User.first

    @redis_test_data = Rails.cache.fetch('temp_key', expires_in: 10.seconds) do
      sleep 3
      'この文字列はredisに入っていたデータです キャッシュを使用しなければ3秒待つようになっています。次回はキャッシュから高速に返答するはずです。このredisのキャッシュは10秒間だけ有効です'
    end
  end
end
