#  demo说明


## 新云端
新云端社区与物业功能除了接口文件不同，其余都大致一样

智能家居功能与空间等接口有关，
需要先选定空间后，通过空间ID`SpaceID`去请求相关数据；
1.选择空间后，保存空间ID到数据库
2.设置WebSocket相关，订阅WebSocket
3.请求WebSocket数据

## 示例代码:
网络请求SDK简要说明
* 初始化
```swift
// 智慧社区 服务器地址
CommunityNetParam.domain = "http://test.gemvary.net:9090"
// 第三方使用SDK需要初始化参数
CommunityNetParam.appId = "55deabd864df42afa4a779811f0a668c"
CommunityNetParam.appSecret = "568f5ac2a827d161a12e1a052e5b6cc7"
// 智能家居appID赋值
SmartHomeManager.appId = "55deabd864df42afa4a779811f0a668c"
// 新云端
NewCloudNetParam.domain = "http://api.gemvary.tech:8443"
NewCloudNetParam.appId = "ea7ed63ea8af41aa9d327def9061cd6d"
NewCloudNetParam.appSecret = "8aab7b3b869208bb8a8b0dd9632ae630"        
```

初始化设置网络请求SDK相关接口的`域名`和`appId`和`appSecret`
具体接口定义可以参见[iOS文档 服务器相关请求接口](http://gemvary.51vip.biz:5000/smarthome_sdk/ios_app_sdk/)部分说明，也可参见demo中具体功能模块中网络请求。

* 智能家居功能简要说明
`WebSocket`处理内容可以参见`demo`的`WebSocketHandler`文件，






智能家居具体协议参考
http://gemvary.51vip.biz:5000
账号:doc 密码:gemvary

1.添加空间
2.添加主机设备
    2.1 主机配网
    2.2 局域网搜索主机设备
3.添加节点设备

## Usage
引入SDK
```
source 'https://github.com/Gemvary/GemvarySpec.git'

  pod 'GemvaryNetworkSDK' #, '~> 0.2.55'
  pod 'GemvarySmartHomeSDK'
  pod 'GemvaryToolSDK'
  pod 'GemvaryCommonSDK'

```

