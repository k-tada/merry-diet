# メリーさんのダイエット講座

## 環境構築
Vagrant用の構築ファイルを作成しています。  
`env/win or mac`に移動し、そこのREADME.mdに従って環境を構築してください。  
構築が完了したら、仮想マシンに入り（`vagrant ssh`で入れます）、以下のコマンドを実行しましょう。  

```
gem install bundler
sudo mkdir -p /var/www
sudo chown vagrant:vagrant /var/www
cd /var/www
git clone https://github.com/k-tada/merry-diet.git
cd merry-diet
bundle install --path vendor/bundle
```

その後、`bundle exec rails s -b 0.0.0.0`を実行し、ホストマシンのブラウザから`Vagrantfile`に記載したipアドレス（3000番ポート）にアクセスしてRailsのスタートメニューが表示されれば環境構築は完了です。  


※ もちろん、自分で構築しても構いません。`git`, `Ruby`, `Node.js`をインストールし、`git clone`して開発を進めてください。  



