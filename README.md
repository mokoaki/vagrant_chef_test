#### Railsの実行環境をVagrant-Chefで作れるようにしようプロジェクト

何が行われるのか？
- CentOS 7.1 のVMを用意（https://github.com/chef/bento）
- Ruby(rbenv) のインスコ
- MySQL(MariaDB) のインスコ

先立ってローカルにインスコする必要があるもの
- VirtualBox
- Vagrant
- git

コマンドラインでこれを打ちましょう
```
$ vagrant plugin install vagrant-omnibus
$ vagrant plugin install vagrant-vbguest

$ mkdir temp
$ cd temp

$ git clone git@github.com:mokoaki/vagrant_chef_test.git
$ cd vagrant_chef_test

$ vagrant up
```

ローカルのソースがVMへマウントされている為、ソース修正はローカルに対して行う  
git操作はローカル、bundle install等はVM上で行う  

```
# VMにてDEV環境を立ち上げる（のかな？）

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
