User.create(name: 'この文字列はDBに入っていたデータです') if User.find_by(id: 1).nil?
