#### Railsの実行環境をChefで作れるようにしようプロジェクト

何が行われるのか？
- CentOS 7.0 のVMを用意（現在は第3者の用意したもの。注意）
- rbenv のインスコ
- Ruby のインスコ（予定）
- Rails のインスコ（予定）
- MySQL のインスコ（予定）

先立ってローカルにインスコする必要があるもの
- VirtualBox
- Vagrant
- git

コマンドラインでこれを打ちましょう
```
$ vagrant plugin install vagrant-omnibus  
$ vagrant plugin install vagrant-vbguest  

$ git clone git@github.com:mokoaki/vagrant_chef_test.git
$ vagrant up
```
