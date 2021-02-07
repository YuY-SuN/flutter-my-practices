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

## sshd
``` sh
apt-get install ssh
apt-get install iputils-ping
apt-get install vim
```

- ポート結んでないので、いったんコンテナをコミットしてイメージ化してまたrun
  ```sh
  docker commit ubuntu-devel-3 ubuntu-with-systemd:1
  docker run -d --privileged -v $PWD:/mnt/host --name "ubuntu-devel-4" -p <bindするip>:22 ubuntu-with-systemd:1 "/sbin/init"
  ```

- iptables
  ```sh
  apt-get install iptables
  iptables -P INPUT DROP
  iptables -A INPUT -s <hostのIP> -p tcp --dport 22 -j ACCEPT
  ```
- ssh
  ```
  ## container側
  cat <hostのpubkey> >> /root/.ssh/authorized_keys
  ## host側
  ssh -i <鍵> root@localhost -p <bindしたip> 
  ```
  - 繋がったー！！
  - root権限は激ヤバなので、useraddした方がいいかな,,

## X11
  - mac側
   ` brew install xquartz `
  - ubuntu側
   ``` sh
   apt-get install x11-apps  
   xeyes
   ```
   - 目が生えてきた！

## Android Studio
```
~/android-studio/bin# ./studio.sh 
> Start Failed: Internal error. Please refer to https://code.google.com/p/android/issues
> 
> com.intellij.ide.plugins.StartupAbortedException: UI initialization failed
> Caused by: java.util.concurrent.CompletionException: java.lang.UnsatisfiedLinkError: /root/android-studio/jre/jre/lib/amd64/libawt_xawt.so: libXtst.so.6: cannot open shared object file: No such file or directory
> Caused by: java.lang.UnsatisfiedLinkError: /root/android-studio/jre/jre/lib/amd64/libawt_xawt.so: libXtst.so.6: cannot open shared object file: No such file or directory
```
- 解決
  `~/android-studio/bin# apt-get install libxrender1 libxtst6 libxi6`
  - インストールできた！

## android emulator
- `Your CPU dose not support reqired features (VT-x or SVM).`

- 何も出ない..
  ``` sh
  cat /proc/cpuinfo | grep svm
  cat /proc/cpuinfo | grep vmx
  ```
  - kvm がないから、 /dev/kvm と結びつけることもできない
  - 無理っぽいので remote で...
- no-accel でいける可能性
  - emulatorを動かすために
  ``` sh
  apt-get install libpulse0
  apt-get install libglu1-mesa
  apt install libnss3
  apt-get install -y xvfb
  ## だめだったような 
  #apt-get install libxcomposite
  #apt-get install libxcomposite-devel
  ## これをして、不足分を洗い出す 
  ldd /root/Android/Sdk/emulator/qemu/linux-x86_64/qemu-system-x86_64
  ## 不足分を入れる
  apt install libc++-dev
  apt-get install qt5-default
  ```
  - まだ動かない
    - `[554:554:0207/073406.611583:ERROR:zygote_host_impl_linux.cc(89)] Running as root without --no-sandbox is not supported. See https://crbug.com/638180.  `
    - `export QTWEBENGINE_DISABLE_SANDBOX=1`
  - 端末の画面は出てきた！が、何も描画されない...

- 混乱してきた...
  - flutter を VMaccelerator なしで動かすアプローチで行ってみたい
  - 整理するかー、、
