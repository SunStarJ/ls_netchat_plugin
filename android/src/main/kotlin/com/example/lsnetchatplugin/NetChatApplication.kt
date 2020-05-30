package com.example.lsnetchatplugin

import com.example.lsnetchatplugin.LsnetchatpluginPlugin.Companion.mContext
import com.netease.nimlib.sdk.NIMClient
import com.netease.nimlib.sdk.SDKOptions
import com.netease.nimlib.sdk.msg.MsgService
import com.netease.nimlib.sdk.util.NIMUtil
import io.flutter.app.FlutterApplication


abstract class NetChatApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        NIMClient.init(applicationContext, null, buildOptions(initApplicationKey()))
        if(NIMUtil.isMainProcess(applicationContext))
        NIMClient.getService(MsgService::class.java).registerCustomAttachmentParser(CustomAttachParser())
    }

    private fun buildOptions(appk:String): SDKOptions {
        val options = SDKOptions();
        options.run {
            appKey = appk
        }
        return  options
    }

    abstract fun initApplicationKey(): String
}