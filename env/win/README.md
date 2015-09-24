# 開発環境構築手順（Windows)

## 1. 準備
### 1-1. 必要ツールのインストール
下記のツールをインストールしてください。  
- VirtualBox
- Vagrant
- Ruby

導入にはChocolateyというツールが便利です。  
参考：http://qiita.com/himinato/items/11f4dc9a23afebbc242c

```
cinst virtualbox
cinst vagrant
cinst ruby
cinst ruby.devkit
cinst chef-client
```

普通に各サイトからインストーラを落としてインストールでもOKです。  
が、RubyのChefインストールは結構手間なので、特別な理由が無ければ  
上述のChocolateyをおすすめします。

インストールが完了したら、コマンドプロンプトから  
```
vagrant --version
ruby -v
gem -v
```
と実行して、各コマンドが有効であることを確認しましょう。  

コマンドが見つからないとか言われたら、  
- コマンドプロンプトの再起動
- Windows再ログイン
- Windows再起動
のいずれかでコマンドが見つかるようになると思います。  

### 1-2. 必要プラグインのセットアップ
VagrantでChefを使うためにはomnibusプラグインが必要なので  

`vagrant plugin install vagrant-omnibus`

でインストールしましょう。

## 2. Vagrant用Boxの準備
CentOS6.5のBoxファイルを下記よりダウンロードして下さい。  
https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box

落としてきたら、下記のコマンドを実行してBoxファイルをVagrantに登録してください。  

```
vagrant box add centos65 <ダウンロードしたBoxファイル名>
```

## 3. 環境構築
ターミナルで`env/win/`の下に移動して、`vagrant up`を実行しましょう。  
かなり時間はかかりますが、あとは待つだけです。  

## 4. 確認
3. と同じディレクトリで、`vagrant ssh`を実行しましょう。  
そうすると、仮想マシンに入ることができます。  
下記のコマンドを実行して、正常に環境ができていることを確認してください。  

```
ruby -v
gem -v
rails -v
node -v
npm -v
```


※ トラブルシューティング的な
・Vagrantが起動できない場合
Windowsの場合、マシンのBIOS設定で仮想化支援機能（Intel Virtualization Technology）が無効になっている可能性があります。  
PC起動時にBIOS画面から、仮想化支援機能の有効化メニューを探しましょう。  



