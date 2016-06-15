class WelcomeController < ActionController::Base
  def index
    @user = User.first

    session[:session_data] ||= "この文字列はセッションデータです。Redis内に保存されています。このセッションは1日間だけ有効です。このセッションは #{Time.now} 頃に作られました"

    @cache_data = Rails.cache.fetch('temp_cache_key', expires_in: 10.seconds) do
      "この文字列はredisでキャッシュしたデータです。このキャッシュは10秒間だけ有効です。このキャッシュは #{Time.now} 頃に作られました"
    end
  end

  def mail
    user = User.first

    UserMailer.welcome_email(user).deliver_later(wait: 10.seconds)

    render text: true
  end
end
