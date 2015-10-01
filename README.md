# Railsの実行環境をVagrant-Chefで作れるようにしようプロジェクト

####何が行われるのか？
- CentOS 7.1 のVMを用意 https://github.com/chef/bento
- Ruby(rbenv) のインスコ
- MySQL(MariaDB) のインスコ
- Redis のインスコ
- Nginx のインスコ
- RubyGem(bundler, nokogiri) のインスコ

####先立ってローカルにインスコしておく必要があるもの
- VirtualBox https://www.virtualbox.org/wiki/Downloads
- Vagrant https://www.vagrantup.com/downloads.html
- git

####TODO
- レシピの適切な構造化
  - 現状はまぁ動けばいいやVer
- Berkshelf の活用（？）
  - 勉強不足
- not_ifをしっかりつける

コマンドラインでこれを打ちましょう
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
```

ローカルのソースがVMへマウントされている為、ソース修正はローカルに対して行う  
git操作はローカルで行う  
bundle install等はVM上で行う  

```
# VMにsshログイン（これはローカルで入力）
$ vagrant ssh

# Rubyの確認してみたりとか
$ ruby -v

# 例えばこんな風にDEV環境を立ち上げたりする（予定）
$ cd rails/project
$ bundle exec rails s

# VMからログアウト
$ exit
```

ちなみにNginxが動いているので http://192.168.56.11 が見れたりする

```
# vagrant 簡単なリファレンス（ローカルで打つコマンド）

# VMシャットダウン
$ vagrant halt

# VM起動
$ vagrant up

# VM削除（もちろん、修正中のソース等には影響はなく、いつでも気軽に削除し、再度作成できる筈である）
$ vagrant destroy

# 他にも
$ vagrant suspend
$ vagrant resume
$ vagrant reload
$ vagrant provision
```
