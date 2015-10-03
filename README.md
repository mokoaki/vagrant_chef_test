# Railsの実行環境をVagrant-Chefで作れるようにしようプロジェクト

####何が行われるのか？
- CentOS 7.1 のVMを用意 https://github.com/chef/bento
- Ruby(rbenv) のインスコ
- MySQL(MariaDB) のインスコ
- Redis のインスコ
- Nginx のインスコ
- RubyGem(bundler, nokogiri) のインスコ
- Railsの設定

####先立ってローカルにインスコしておく必要があるもの
- VirtualBox https://www.virtualbox.org/wiki/Downloads
- Vagrant https://www.vagrantup.com/downloads.html
- git

####VM作成するのに最低限必要なのは
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
```

http://192.168.56.11/ を確認しましょう  

ローカルのソースがVMへマウントされている為、ソース修正はローカルに対して行う  
git操作はローカルで行う  
bundle install等はVM上で行う  

```
# VMにsshログイン（これはローカルで入力）
$ vagrant ssh

# Rubyの確認してみたりとか
$ ruby -v

# VMからログアウト
$ exit
```

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
