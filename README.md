# nanohat-oled

[cho45さん](https://github.com/cho45)の[nanohat-oled-nodejs](https://github.com/cho45/nanohat-oled-nodejs)をDocker化およびkubernetesで動作するようにしたものです。

一部に修正をしているので[yasu-hide/nanohat-oled-nodejs](https://github.com/yasu-hide/nanohat-oled-nodejs)をサブモジュールにしています。

# Docker
### ビルド
Nano Pi のARM64向けにbuildkit拡張 `--platform linux/arm64` を使用してビルドします。
```
docker buildx build --platform linux/arm64 -f Dockerfile --push -t nanohat-oled:latest .
```

### 実行
```
docker run -d --privileged --cap-add SYS_ADMIN nanohat-oled:latest
```

# k8s

```
$ kubectl apply -f k8s-nanohat-oled.yml
```

## GPIO & SYSFS
ボタンの押下の認識にGPIOを使用している都合でsysfsを操作しています。

SYS_ADMIN capabilityと、privilegedによる特権昇格を有効にしています。

ボタンの扱いが不要で特権昇格を許可しない場合は、YAMLファイルを編集してからapplyしてください。

sysfsが操作できなかったメッセージが記録されます。

```
EROFS: read-only file system, open '/sys/class/gpio/export'
```

# 参考
- NanoPi NEO2 でやること、NanoHat OLED のメモ書き | tech - 氾濫原 - https://lowreal.net/2018/09/28/1