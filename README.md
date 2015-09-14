#### Railsの実行環境をVagrant-Chefで作れるようにしようプロジェクト

何が行われるのか？
- CentOS 7.0 のVMを用意（現在は第3者の用意したもの。注意）
- rbenv のインスコ
- Ruby のインスコ
- MySQL(MariaDB) のインスコ

先立ってローカルにインスコする必要があるもの
- VirtualBox
- Vagrant
- git

コマンドラインでこれを打ちましょう
```
$ mkdir temp
$ cd temp

$ vagrant plugin install vagrant-omnibus  
$ vagrant plugin install vagrant-vbguest  

$ git clone git@github.com:mokoaki/vagrant_chef_test.git
$ vagrant up
```

```
$ vagrant ssh

# vmにてDEV環境を立ち上げる想定

$ cd rails/project
$ bundle exec rails s

# ローカルのソースがマウントされている為、修正はローカルのファイルに対して行う

# git操作はローカル、bundle install等はVM上で行う想定
```
