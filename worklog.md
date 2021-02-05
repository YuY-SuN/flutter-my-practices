## docker hub から ubuntuを落とす
- `registry.hub.docker.com/library/ubuntu:latest`

## ubuntu 起動
- `docker run -it -d --privileged -v $PWD:/mnt/host --name "ubuntu-devel" f63181f19b2f`  
- 補足 
  - `-it` で 入力の接続と端末の割り当てを行っている（適当）
  - `--priviledge` で 特権モード起動
  - `-v` で host : guest のdir を繋ぐ。 guest が host の ディレクトリを mount しているイメージ。

## dart
- https://dart.dev/get-dart
  ``` sh
  apt-get update
  apt-get install apt-transport-https
  apt-get install gnupg
  sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
  sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
  apt-get update
  apt-get install dart
  history
  export PATH="$PATH:/usr/lib/dart/bin"
  dart --version
  ```

## flutter
- snapd をインストールする過程で systemd が入ってきた。 daemonだし当然か、、daemon、、
- コマンドたち
  ``` sh
  apt-get install -y git
  apt-get install -y unzip
  apt-get install -y xz-utils
  apt-get install -y libglu1-mesa
  cat /etc/os-release
  snap
  apt-get install -y snap
  apt-get install -y snapd
  ```
- やっぱなー、、
  ``` sh
  snap install flutter --classic
  > error: cannot communicate with server: Post http://localhost/v2/snaps/flutter: dial unix /run/snapd.socket: connect: no such file or directory
  /lib/systemd/systemd
  > Trying to run as user instance, but the system has not been booted with systemd.
  ```
- 元々systemd 入ってないのか、、
- docker build だ！
  ``` sh
  systemctl restart snapd
  snap install flutter --classic
  ```
  - snapは失敗したが、動きはしたぞ。ベネ
  - おん？二度目打ったらいったぞ、何が起きているんだ
  - `flutter 0+git.a051085 from Flutter Team* installed`
  - よき
- flutter のbuildだろうか
  ``` sh
  > Warning: /snap/bin was not found in your $PATH. If you've not restarted your session since you
  >          installed snapd, try doing that. Please see https://forum.snapcraft.io/t/9469 for more
  >          details.
  > 
  > flutter 0+git.a051085 from Flutter Team* installed
  flutter sdk-path
  > bash: flutter: command not found
  export PATH=$PATH:/snap/bin
  flutter sdk-path
  ```
  - こうなった
    ``` sh
    ╔════════════════════════════════════════════════════════════════════════════╗
    ║                 Welcome to Flutter! - https://flutter.dev                  ║
    ║                                                                            ║
    ║ The Flutter tool uses Google Analytics to anonymously report feature usage ║
    ║ statistics and basic crash reports. This data is used to help improve      ║
    ║ Flutter tools over time.                                                   ║
    ...
    ```

- これ終わってから見かけたもの
  - [Install Flutter manually](https://flutter.dev/docs/get-started/install/linux#install-flutter-manually)
  - ＿人人人人人人＿  
    ＞　ギュアア　＜  
    ￣Y^Y^Y^Y^Y^Y^￣  


