# Railsの開発環境をVagrant-Chefで作れるようにしようプロジェクト

####ブラウザ ← unicorn ← Rails ← (MySQL, Redis)

####何が行われるのか？
- CentOS 7.1 のVMを用意 https://github.com/chef/bento
- Ruby(rbenv) のインスコ
- MySQL(MariaDB) のインスコ
- Redis のインスコ
- ~~Nginx のインスコ~~（開発環境にnginxなぞ要らん！という神の啓示で削除 昔のコミットにはある）
- RubyGem(bundler, nokogiri) のインスコ
- Railsの設定

####先立ってローカルにインスコしておく必要があるもの
- VirtualBox https://www.virtualbox.org/wiki/Downloads
- Vagrant https://www.vagrantup.com/downloads.html
- git

####VM作成するのに最低限必要なファイルは
- Vagrantfile
- cookbooks/
この2つだけ 他はRailsのサンプルアプリ関係とか

####TODO
- レシピの適切な構造化、お作法
  - 現状はまぁ動けばいいやVer
- Berkshelfの活用（要るのか？）
  - 勉強不足

####では、やってみましょう
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

# VMにsshログイン（これはローカルで入力）
$ vagrant ssh

$ cd /vagrant

# unicorn起動
$ bundle exec spring rake unicorn:start
```

http://192.168.56.11:3000/ を確認しましょう  

```
# Rubyの確認してみたりとか
$ ruby -v

# VMからログアウトしてみたりとか
$ exit
```

ソース修正はローカルに対して行う（ローカルのソースがVMへマウントされている）  
git操作はローカルで行う  
bundle install的なコマンドはVM上で行う  

```
# vagrant 簡単なリファレンス（ローカルで打つコマンド）

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
```
