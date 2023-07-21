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

```

git push -u origin main
```

## Usage
引入SDK
```
source 'https://github.com/Gemvary/GemvarySpec.git'

  pod 'GemvaryNetworkSDK' #, '~> 0.2.55'
  pod 'GemvarySmartHomeSDK'
  pod 'GemvaryToolSDK'
  pod 'GemvaryCommonSDK'

```

### 新设备上报
{\"msg_type\":\"new_device_manager\",\"command\":\"up\",\"from_role\":\"business\",\"from_account\":\"259173ce40164413\",\"devices\":[{\"alloc_room\":0,\"new_dev_id\":0,\"dev_addr\":\"ccccccfffe18188a\",\"riu_id\":3,\"gateway_type\":\"zigbee\",\"dev_class_type\":\"smoke\",\"dev_net_addr\":\"f3fe\",\"dev_uptype\":0,\"brand\":\"gemvary.mlk\",\"host_mac\":\"259173ce40164413\",\"dev_key\":1,\"dev_state\":\"{\\\"status\\\":\\\"on\\\",\\\"value\\\":1}\"}]}

{\"msg_type\":\"device_online_manager\",\"from_role\":\"devconn\",\"from_account\":\"259173ce40164413\",\"command\":\"up\",\"brand\":\"gemvary.lumi\",\"dev_class_type\":\"\",\"dev_uptype\":0,\"devices\":[{\"dev_addr\":\"ccccccfffe18188a\",\"dev_net_addr\":\"f3fe\",\"online\":1,\"dev_key\":1,\"attr\":\"\",\"brand\":\"gemvary.lumi\"}]}

### 添加设备到房间
{\"gid\":\"6d79e8a99e61479591865ef04786b6d8\",\"product_id\":\"9c179ba94e5e42acaa57b82ffc78afea\",\"group_id\":\"DA93F72E-B90B-4E93-9860-2CA03DC5500F\",\"msg_type\":\"device_manager\",\"from_role\":\"phone\",\"from_account\":\"15989760200\",\"riu_id\":3,\"dev_class_type\":\"smoke\",\"dev_addr\":\"ccccccfffe18188a\",\"dev_net_addr\":\"f3fe\",\"dev_uptype\":0,\"dev_key\":1,\"brand_logo\":\"http://gemvary.51vip.biz:3333/product-imgs/product/9c179ba94e5e42acaa57b82ffc78afea/38851c618e0528d75dc285e109f53c9c.jpg\",\"brand\":\"gemvary.mlk\",\"dev_state\":\"{\\\"status\\\":\\\"on\\\",\\\"value\\\":1}\",\"dev_additional\":\"\",\"channel_id\":0,\"online\":1,\"duration\":1,\"host_mac\":\"259173ce40164413\",\"command\":\"add\",\"room_name\":\"默认\",\"dev_name\":\"烟雾传感器1\",\"gateway_type\":\"zigbee\",\"active\":1}

### 传进来的设备信息
    hostDevice =     {
        active = 0;
        authorization = 0;
        brand = gemvary;
        "brand_logo" = "http://gemvary.51vip.biz:3333/product-imgs/product/57f819545a1442b1b0dcc46d4f3a0b18/c48c4685d0ef8a13103bcc389b4cd119.jpg";
        "channel_id" = 0;
        data = "";
        "dev_additional" = "";
        "dev_addr" = 259173ce40164413;
        "dev_class_type" = "gateway.rk3128";
        "dev_id" = 6;
        "dev_key" = 1;
        "dev_name" = "\U5b89\U5353\U5ba4\U5185\U673a";
        "dev_net_addr" = "192.168.10.56";
        "dev_scene" = 0;
        "dev_state" = "";
        "dev_uptype" = 0;
        duration = 1;
        "exe_flag" = 0;
        frontdisplay = "";
        "func_cmd" = "";
        "func_define" = "";
        "gateway_type" = "wifi_Module";
        gid = 166dcda2222446079ec96990f54d85bf;
        "group_id" = "f43beabf-3eb7-47cb-92dc-b0a3ffe649fb";
        heartbeat = 0;
        "host_mac" = 259173ce40164413;
        "hw_ver" = "";
        id = 1655;
        model = "";
        "old_status" = "";
        online = 1;
        "product_id" = 57f819545a1442b1b0dcc46d4f3a0b18;
        "resend_count" = 0;
        "riu_id" = 1;
        "room_name" = "\U6b21\U5367";
        "shortcut_flag" = 0;
        "smart_flag" = 0;
        "state_update_flag" = 0;
        "study_flag" = 0;
        udatetime = 1689840998;
    };
    manualProductInfo =     {
        appShow = 1;
        brand = "gemvary.mlk";
        categoryId = 42;
        categoryName = "\U70df\U96fe\U4f20\U611f\U5668";
        classType = smoke;
        definition = "[]";
        devType = smoke;
        gatewayType = zigbee;
        gid = "<null>";
        hwid = "<null>";
        id = 9c179ba94e5e42acaa57b82ffc78afea;
        imgList =         (
        );
        imgUrl = "http://gemvary.51vip.biz:3333/product-imgs/product/9c179ba94e5e42acaa57b82ffc78afea/38851c618e0528d75dc285e109f53c9c.jpg";
        manual = "\U957f\U6309\U6d4b\U8bd5\U6309\U94ae\Uff0c\U76f4\U5230\U6307\U793a\U706f\U7531\U7ea2\U8272\U53d8\U4e3a\U7eff\U8272\U95ea\U70c1";
        manualUrl = "<null>";
        manufacturerId = GEMVARY;
        model = "MIR-SM100";
        name = "\U65e0\U7ebf\U70df\U96fe\U4f20\U611f\U5668";
        productId = 9c179ba94e5e42acaa57b82ffc78afea;
        "riu_id" = 3;
        sort = 1;
        upType = 0;
    };
