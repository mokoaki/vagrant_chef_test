# Railsの開発環境をVagrant-Chefで作れるようにしようプロジェクト

#### ブラウザ ← unicorn ← Rails ← (MySQL, Redis)

あと sidekiq による非同期メール送信テスト

#### 何が行われるのか？
- CentOS 7.2 のVMを用意 https://github.com/chef/bento
- Ruby(rbenv) のインスコ
- MySQL(MariaDB) のインスコ
- Redis のインスコ
- ~~Nginx のインスコ~~（開発環境にnginxなぞ要らん！という神の啓示で削除 昔のコミットにはある）
- bundler のインスコ
- Rails の設定

#### 先立ってローカルにインスコしておく必要があるもの
- VirtualBox https://www.virtualbox.org/wiki/Downloads
- Vagrant https://www.vagrantup.com/downloads.html
- git

#### TODO
- レシピの適切な構造化、お作法
  - 現状はまぁ動けばいいやVer
- Berkshelfの活用（要るのか？）
  - 勉強不足

#### では、やってみましょう
```
$ vagrant plugin install vagrant-omnibus
$ vagrant plugin install vagrant-vbguest

$ mkdir temp
$ cd temp

$ git clone git@github.com:mokoaki/vagrant_chef_test.git
$ cd vagrant_chef_test

$ vagrant up

# 数10分ほど画面を見ながらニヤニヤする
# ちなみに途中でローカルのパスワードを聞かれる ローカルディレクトリマウントの為

# 待っている間に
$ config/secrets.yml.sample を config/secrets.yml にコピーしてGmailのメアドとパスを書いておくとメールのテストができる

# VMにsshログイン
$ vagrant ssh
$ cd /vagrant

# メール出すためのワーカ起動
$ bundle exec sidekiq -C config/sidekiq.yml

# もう一つコンソールを起動して
$ vagrant ssh
$ cd /vagrant

# unicorn起動
$ bin/rails s -b 0.0.0.0
もしくは
$ bin/rake unicorn:start
```

http://192.168.56.11:3000/ を確認しましょう

```
# Rubyの確認してみたりとか
$ ruby -v

# テストしてみたりとか(PhantomJS使ってるので、jsのテストも出来る筈)
$ cd /vagrant
$ bin/rspec spec/

# VMからログアウトしてみたりとか
$ exit
```

ソース修正はローカルに対して行う（ローカルのソースがVMへマウントされている）

git操作はローカルで行う

bundle install 的なコマンドはVM上で行う

#### エラーすか

`Too many open files - getcwd (Errno::EMFILE)`

ファイルディスクリプタの上限オーバー、数を確認して増やす

```
# MACならこんな感じ 他は適当に

$ ulimit -n
256
# 現在256っすか

$ ulimit -n 512
# とりあえず512を指定

$ vagrant reload --provision
# 適当にやりなおす
```

#### vagrant 簡単なコマンドリスト（ローカルで打つコマンドだよ）

```
# VMシャットダウン
$ vagrant halt

# VM起動
$ vagrant up

# VM削除（もちろん、修正中のソース等には影響はなく、いつでも気軽に削除し、作り直せる筈である）
$ vagrant destroy

# 他にも
$ vagrant suspend
$ vagrant resume
$ vagrant reload
$ vagrant provision
$ vagrant reload --provision
$ vagrant up --provision
$ vagrant up --no-provision
$ vagrant box list
$ vagrant box remove bento/centos-7.2 --box-version 2.2.6
```
