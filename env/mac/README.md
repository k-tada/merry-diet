# 開発環境構築手順（Mac）

## 1. 準備
下記のツールをインストールしてください。  

- VirtualBox
- Vagrant
- Ansible

Homebrewを導入しているなら、下記のコマンドでOKです。  

```
brew install ansible
brew cask install virtualbox
brew cask install vagrant
```

## 2. Vagrant用Boxの準備
CentOS6.5のBoxファイルを下記よりダウンロードして下さい。  
https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box

落としてきたら、下記のコマンドを実行してBoxファイルをVagrantに登録してください。  

```
vagrant box add centos65 <ダウンロードしたBoxファイル名>
```

## 3. 環境構築
ターミナルで`env/mac/`の下に移動して、`vagrant up`を実行しましょう。  
かなり時間はかかりますが、あとは待つだけです。  

## 4. 確認
3. と同じディレクトリで、`vagrant ssh`を実行しましょう。  
そうすると、仮想マシンに入ることができます。  
下記のコマンドを実行して、正常に環境ができていることを確認してください。  

```
ruby -v
gem -v
node -v
npm -v
```
