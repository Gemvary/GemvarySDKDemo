# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

# 指定开源库的下载源（组件化开发时会用到）
source 'https://github.com/CocoaPods/Specs.git'
#source 'https://github.com/songmenglong/SMLSpec.git'
source 'https://github.com/Gemvary/GemvarySpec.git'

target 'GemvarySDKDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GemvarySDKDemo
  pod 'GRDB.swift' # 数据库 可以并发处理数据
  pod 'CleanJSON' # 解析数据
  pod 'WebViewJavascriptBridge', '~> 6.0'
  pod 'Alamofire'
  pod 'RealReachability'
  
  pod 'MJRefresh'
  pod 'CocoaAsyncSocket'
  
  #pod 'ZegoExpressEngine'
    
  pod 'GemvaryNetworkSDK'
  pod 'GemvarySmartHomeSDK'
  pod 'GemvaryToolSDK'
  
#  pod 'GemvaryZGCloudCallSDK'
  # 由于依赖库ZegoExpressEngine不能正常导入的缘故 只能上传到git打包 通过git方式引入(非cocoapod说验证上传方式)
#  pod 'GemvaryZGCloudCallSDK', :branch =>'0.1.10', :git => 'http://192.192.0.118:3000/songmenglong/GemvaryZGCloudCallSDK.git'
  pod 'GemvaryCommonSDK'
#  pod 'LifeSmartSDK'
  
  pod 'SnapKit' # 约束布局
#  pod 'SMLTool'
  
  target 'GemvarySDKDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GemvarySDKDemoUITests' do
    # Pods for testing
  end

end
